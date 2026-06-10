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

## Configuration

During the setup process, you shall be prompted to configure the following:

- **Google API Keys**: Enter your Google API keys for Gemini models
- **Port**: Specify the port for the service (default: 7070)
- **Proxy**: Optionally configure a proxy for outbound requests (e.g., `http://proxy.example.com:8080`)
- **Master Key**: Optionally set a master key to secure your proxy

The proxy configuration, if provided, will be saved to the `.env` file as `HTTP_PROXY` and `HTTPS_PROXY` variables, which Docker Compose will automatically load.

