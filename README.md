# Frontend Dockerized Template

🚀 A comprehensive Docker-based development environment for modern JavaScript frameworks with intelligent port detection and multi-framework support. This template provides a containerized setup that ensures consistent development environments across different machines while automatically configuring ports based on your chosen framework.

## ✨ Features

- 🐳 **Docker-based development environment** - Consistent setup across all machines
- 🧠 **Intelligent framework detection** - Automatically detects and configures your framework
- ⚛️ **Multiple framework support**:
  - **Expo** (React Native) - Port 8081
  - **Fastify** - Port 3000
  - **Next.js** (App Router) - Port 3000
  - **React** (with React Router v7) - Port 5173
  - **Vue.js** - Port 5173
  - **Vite** - Port 5173
  - **Custom frameworks** - Port 8080
- 🎯 **Smart port management** - No manual port configuration needed
- 🔧 **Make-based workflow** - Simple commands for all operations
- � **Hot reload support** - Instant development feedback
- 👤 **Non-root user setup** - Secure container execution
- 📦 **Volume mounting** - Persistent development files
- 🛠️ **Extensible architecture** - Easy to add new frameworks

## 🎯 Smart Port Management

**Zero configuration required!** The template automatically detects your framework and configures the appropriate ports:

| Framework | Default Port | Detection Method | Status |
| ---- | --- | --- | --- |
| Expo | 8081 | `"expo"` or `"@expo/"` | ✅ Fully Supported |
| Fastify | 3000 | `"next"` dependency | ✅ Fully Supported |
| Next.js | 3000 | `"next"` dependency | ✅ Fully Supported |
| React | 5173 | `"react"` (without Next.js) | ✅ Fully Supported |
| Vue.js | 5173 | `"vue"` dependency | ✅ Fully Supported |
| Vite | 5173 | `"vite"` dependency | ✅ Fully Supported |
| **Custom** | **8080** | **Unknown framework** | ✅ **Supported via `init-framework`** |

### How It Works

When you run `make up`, the system will:

1. 📝 Scan your `package.json` for framework dependencies
2. 🔍 Detect the framework type automatically
3. ⚙️ Configure appropriate ports without manual intervention
4. 🚀 Start your development server with the correct configuration

**Example output:**

```bash
$ make up
Detected framework: next (port: 3000)
Using ports: Host: 3000 -> Container: 3000
Soon your project will be available at http://localhost:3000
```

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (with Docker Compose v2+)
- [Make](https://www.gnu.org/software/make/) (usually pre-installed on Linux/macOS)

## 🚀 Quick Start

### 1. Clone or use this template

```bash
git clone <repository-url>
cd react-dockerized
```

### 2. Configure your project (optional)

Edit the `.env` file to customize your project settings:

```env
IMAGE_NAME=frontend-dockerized-app
PROJECT_NAME=my_project
NODE_ENV=development
```

### 3. Initialize your application

Choose one of the predefined frameworks:

**For Next.js (recommended for web apps):**

```bash
make init-next
```

**For React Router (traditional React apps):**

```bash
make init-react
```

**For Expo (React Native apps):**

```bash
make init-expo
```

**For Vue.js applications:**

```bash
make init-vue
```

**For Vite applications:**

```bash
make init-vite
```

### 4. Start the development server

```bash
make up
```

### 5. Open your application

Navigate to the automatically detected port in your browser (depending on your framework).

## 🔧 Custom Framework Support

For frameworks not directly supported, use the `init-framework` command with a custom create command:

### Syntax

```bash
make init-framework CREATE_COMMAND="<your-custom-command>"
```

### Examples

**Create a Svelte application:**

```bash
make init-framework CREATE_COMMAND="npm create svelte@latest my_project"
```

**Create a Remix application:**

```bash
make init-framework CREATE_COMMAND="npx create-remix@latest my_project"
```

**Create a Nuxt.js application:**

```bash
make init-framework CREATE_COMMAND="npx nuxi@latest init my_project"
```

**Note:** Custom frameworks will default to port **8080**. The development server will be available at [http://localhost:8080](http://localhost:8080).

## 📖 Available Commands

Run `make help` to see all available commands with descriptions.

### Example npm commands

```bash
# Install packages
make npm install lodash

# Install dev dependencies - note about double `--`!
make npm install typescript -- --save-dev

# Run custom scripts
make npm run build

# Check versions
make npm list
```

## 🛠️ Development Workflow

### Getting Started

1. **Initialize your project:**

   ```bash
   make init-next  # or any other supported framework
   ```

2. **Start development:**

   ```bash
   make up
   ```

3. **Install additional packages:**

   ```bash
   make npm install <package-name>
   ```

4. **Run custom npm scripts:**

   ```bash
   make npm run <script-name>
   ```

5. **Access container for debugging:**

   ```bash
   make shell
   ```

6. **Stop development:**

   ```bash
   make down
   ```

## 📁 Project Structure

After initialization, your project will have the following structure:

```text
react-dockerized/
├── .env                    # Environment configuration
├── compose.yaml           # Docker Compose services
├── Dockerfile             # Container definition
├── Makefile              # Development commands
├── LICENSE               # MIT License
├── README.md             # This file
├── docker/               # Docker utilities
│   ├── detect-framework.sh   # Framework detection script
│   ├── entrypoint.sh         # Container startup script
│   └── port-config.sh        # Port configuration logic
└── <your-project>/       # Your application (created after init)
    ├── package.json
    ├── src/
    └── ... (framework-specific files)
```

## ⚙️ Configuration

### Environment Variables (.env)

| Variable | Description | Default Value |
| --- | --- | --- |
| `IMAGE_NAME` | Docker container name | `react-dockerized-app` |
| `PROJECT_NAME` | Directory name for your project | `my_project` |
| `NODE_ENV` | Node.js environment | `development` |
| `PORT_HOST` | Host port (auto-detected) | Framework-dependent |
| `PORT_CONTAINER` | Container port (auto-detected) | Framework-dependent |

### Port Configuration

Ports are automatically detected, but you can override them by modifying the port mapping in `compose.yaml`:

```yaml
ports:
  - "3001:${PORT_CONTAINER}"  # Change 3001 to your desired host port
```

### Custom Framework Configuration

When using `init-framework` with custom commands, the system will:

1. Use port **8080** as default for unknown frameworks
2. Attempt to detect the framework from the generated `package.json`
3. Update port configuration accordingly after detection

## 🔧 Troubleshooting

### Permission Issues

If you encounter permission issues, the Dockerfile creates a non-root user with UID 1000. Make sure your host user has the same UID or adjust the Dockerfile accordingly:

```bash
# Check your UID
id -u

# If different from 1000, modify Dockerfile:
# ARG USER_UID=<your-uid>
```

### Container Not Starting

1. **Check if the port is already in use:**

   ```bash
   lsof -i :3000  # or your framework's port
   ```

2. **Ensure Docker is running:**

   ```bash
   docker --version
   docker compose version
   ```

3. **Check container logs:**

   ```bash
   docker logs react-dockerized-app
   ```

### Project Not Found

If the project directory doesn't exist, run one of the init commands first:

```bash
make init-next  # or init-react, init-expo, init-vue, init-vite
```

### Framework Not Detected

If your framework isn't detected properly:

1. Check if the framework dependency is in `package.json`
2. Try rebuilding with framework detection:

   ```bash
   make build-smart
   ```

3. For custom frameworks, ensure your command creates a valid `package.json`

## 🤝 Contributing

We welcome contributions to improve this template! Here's how you can help:

For detailed contributing guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📄 License

This project is open source and available under the **MIT License**. See the [LICENSE](LICENSE) file for the full license text.

You are free to:

- ✅ Use this project commercially
- ✅ Modify and distribute
- ✅ Include in private projects
- ✅ Use for educational purposes

---

Happy coding! 🚀

If you find this template helpful, please consider giving it a ⭐!
