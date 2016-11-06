defmodule Tada.List do
  use Tada.Web, :model

  schema "lists" do
    field :uuid, Ecto.UUID
    field :title, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :items, Tada.Item

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(title password), [])
    |> validate_length(:title, min: 3, max: 64)
    |> put_uuid()
    |> unique_constraint(:uuid)
    |> put_pass_hash()
  end

  defp put_uuid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :uuid, UUID.uuid1())
      _ ->
        changeset
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end

defimpl Phoenix.Param, for: Tada.List do
  def to_param(%{uuid: uuid}) do
    uuid
  end
end
