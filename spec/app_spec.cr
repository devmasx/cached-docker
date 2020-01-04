require "./spec_helper"

app = App.new(
  "gcr.io/docker-rails-258302/rails-sqlite",
  "v1",
  ""
)

puts app.run
