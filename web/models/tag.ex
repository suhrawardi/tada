defmodule Tada.Tag do
  use Tada.Web, :model

  schema "tags" do
    field :name, :string
    belongs_to :item, Tada.Item

    timestamps
  end
end
