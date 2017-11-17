defmodule SefazMetrics.Data.Fetch do

  require Logger

  @site "http://www.nfe.fazenda.gov.br/portal/infoEstatisticas.aspx"

  def fetch do
    case poison_get(@site) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info("Fetch succesful")

        {nfe_quant, emitter_quant} =  parse_html(body)
        { :ok,
        %{date: Timex.today(),
          nfe_quant: nfe_quant,
          emitter_quant: emitter_quant
          }
        }

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info("Fail to fetch: 404.")

        { :error, "Fail to fetch: 404." }

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.info("Fail to fetch: #{reason}.")

        { :error, "Fail to fetch: #{reason}." }
    end

    end

    defp poison_get(url) do
      HTTPoison.get(url, [], [recv_timeout: 30_000, timeout: 30_000, ssl: [{:versions, [:'tlsv1.2']}]])
    end

    defp parse_html(body) do
      utf8_body = convert_body_enconding(body)
      nfe_quant = utf8_body
      |> find_in_html("#ctl00_ContentPlaceHolder1_lblValorNFeAutorizada")
      emitter_quant = utf8_body
      |> find_in_html("#ctl00_ContentPlaceHolder1_lblValorEmissores")
      {nfe_quant, emitter_quant}
    end

    defp convert_body_enconding(body) do
      case :unicode.characters_to_binary(body, :latin1) do
        {:error, binary, rest_data} ->

          Logger.warn("Unable to convert Html body from :latin1")
          Logger.debug(inspect(rest_data))

          binary

        {:incomplete, binary, _binary_2} ->

          Logger.warn("Incomplete conversion of Html body from :latin1")
          Logger.debug(inspect(binary))

          binary
        binary ->

          Logger.info("Conversion was OK")

          binary
      end
    end

    defp find_in_html(body, elem_id) do
      body
      |> Floki.find(elem_id)
      |> Floki.text
      |> human_to_number
    end

    defp human_to_number(string) do
      string
      |> String.split(" ")
      |> multiply
    end

    defp multiply([number_string, unit]) do
      number = number_string
      |> String.replace(",", ".")
      |> String.to_float
      multiply(number, unit)
    end

    defp multiply(number, "milhões") do
      number * :math.pow(10, 6)
    end
    defp multiply(number, "bilhões") do
      number * :math.pow(10, 9)
    end
    defp multiply(number, "trilhões") do
      number * :math.pow(10, 12)
    end


  end
