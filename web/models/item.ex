defmodule Tada.Item do
  use Tada.Web, :model

  schema "items" do
    field :title, :string
    field :order, :integer
    field :status, :string
    field :content, :string
    field :due_date, Ecto.DateTime

    timestamps

    has_many :tags, Tada.Tag
    belongs_to :list, Tada.List
  end
end
