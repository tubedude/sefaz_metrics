# SefazMetrics

A parser for the Brazilian NF-e statistics website.

It will ping http://www.nfe.fazenda.gov.br/portal/infoEstatisticas.aspx every hour
and store the number of NF-e and the number of emitters every day.

## Nanobox
Using nanobox to deploy:
Clone this git and run with `nanobox run`

## Phoenix
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
