# homeserver

### Sops Setup

1. Get your age key (private and public key) and save the private key under:

```bash
~/.config/sops/age-key.txt
````

2. Generate the corresponding public key:

```bash
age-keygen -y ~/.config/sops/age-key.txt > ~/.config/sops/age-key.pub
```

3. Set proper permissions on the private key:

```bash
chmod 600 ~/.config/sops/age-key.txt
```

---

### Managing Secrets with sops-nix

All secrets are stored encrypted using [`sops`](https://github.com/mozilla/sops) and your age key. To add a new secret:

1. Make sure your **private key** is available at `~/.config/sops/age-key.txt`.
2. Create a new plaintext secret file locally, for example:

```bash
echo "DB_PASSWORD=supersecret123" > secrets/db.yaml
```

3. Encrypt the secret using the **public key**:

```bash
sops --encrypt --age $(cat ~/.config/sops/age-key.pub) secrets/db.yaml > secrets/db.enc.yaml
rm secrets/db.yaml
```

4. Commit **only the encrypted file** (`secrets/db.enc.yaml`) to your repo.
5. `sops-nix` will automatically decrypt the secrets at build/deploy time in NixOS.
6. Always **backup your private key** (Bitwarden, USB, or other secure storage). Without it, secrets cannot be decrypted.
