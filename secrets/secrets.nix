let
  # SSH Keys
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFosVd9OTh0sOW6B2+29l/kTR4u9lJZ/eMPaxH3I45td";
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMSoS4kqlQTPy/OWzzpyVLTTVnoAUQkJ+0QQn0OWPInS";

  allKeys = [ server macbook ];
in
{
  "beszel-key.age".publicKeys = allKeys;
  "beszel-token.age".publicKeys = allKeys;
  "n8n-user.age".publicKeys = allKeys;
  "n8n-password.age".publicKeys = allKeys;
  "stirling-user.age".publicKeys = allKeys;
  "stirling-password.age".publicKeys = allKeys;
  "hermes-api-key.age".publicKeys = allKeys;
  "open-webui-api-key.age".publicKeys = allKeys;
}
