# litellm-router

## Quick Installation

The most expeditious method to commence your journey is to employ our curl installer:

```bash
curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/curl-setup.sh | sh
```

Should you wish to specify a custom installation directory:

```bash
curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/curl-setup.sh | sh -s /custom/path
```

Alternatively, should you prefer the Node.js approach, you may utilise npx:

```bash
npx litellm-router-installer
```

With a custom path:

```bash
npx litellm-router-installer /custom/path
```

For those inclined towards Python, uvx is at your disposal:

```bash
uvx --from git+https://github.com/vvmspace/litellm-router.git litellm-router-install
```

With a custom path:

```bash
uvx --from git+https://github.com/vvmspace/litellm-router.git litellm-router-install /custom/path
```

Pray note that the npx and uvx installers are merely elegant wrappers that procure and execute the curl installer on your behalf. Any of these methods shall automatically procure the project and execute the setup script.

