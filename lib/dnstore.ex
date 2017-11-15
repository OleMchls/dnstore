defmodule Dnstore do
  @moduledoc """
  Documentation for Dnstore.
  """

  @client %Dnsimple.Client{access_token: Application.get_env(:dnstore, :token)}
  @zone Application.get_env(:dnstore, :domain)
  @account Application.get_env(:dnstore, :account_id)

  @doc """
  Hello world.

  ## Examples

      iex> Dnstore.hello
      :world

  """
  def set(key, value) do
    Dnsimple.Zones.create_zone_record(@client, @account, @zone, %{
      name: keyify(key),
      type: "TXT",
      content: Cipher.encrypt(value),
      ttl: 60,
    })
  end

  defp keyify(key) do
    :crypto.hash(:sha256, key)
    |> Base.encode16
    |> String.downcase
    |> String.slice(0..8)
  end
end
