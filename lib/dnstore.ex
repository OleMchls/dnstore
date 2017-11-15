defmodule Dnstore do

  @client %Dnsimple.Client{access_token: Application.get_env(:dnstore, :token)}
  @zone Application.get_env(:dnstore, :domain)
  @account Application.get_env(:dnstore, :account_id)

  def set(key, value) do
    Dnsimple.Zones.create_zone_record(@client, @account, @zone, %{
      name: keyify(key),
      type: "TXT",
      content: Cipher.encrypt(value),
      ttl: 60,
    })
  end

  def get(key) do
    fqdn = String.to_charlist("#{keyify(key)}.#{@zone}")
    [[ value ]] = :inet_res.lookup(fqdn, :in, :txt)
    Cipher.decrypt(to_string(value))
  end

  defp keyify(key) do
    :crypto.hash(:sha256, key)
    |> Base.encode16
    |> String.downcase
    |> String.slice(0..8)
  end
end
