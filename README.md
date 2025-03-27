# Personal Blog

This is a Jekyll-based personal blog deployed on GitHub Pages.

## Local Development Setup

### Prerequisites

-   RVM (Ruby Version Manager)
-   Homebrew (recommended for macOS users)

### Quick Setup

The easiest way to set up the development environment is to use the provided setup script:

```bash
# Install RVM if you don't have it
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm  # Load RVM

# For macOS users, install Homebrew if you don't have it
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Run the setup script
./setup.sh
```

This script will:

1. Check if RVM is installed
2. Install Ruby 3.2.2 if needed (with proper OpenSSL configuration for macOS)
3. Create a dedicated gemset for the project
4. Install bundler and required gems

### Running the site locally

After setup is complete, you can run the site locally using:

```bash
./serve.sh
```

This will start a development server at `http://localhost:4000` with live reloading enabled.

### Manual Setup (Alternative)

If you prefer to set up manually or encounter issues with the setup script:

1. Install Ruby 3.2.x using RVM:

    ```bash
    \curl -sSL https://get.rvm.io | bash -s stable  # Install RVM if needed
    source ~/.rvm/scripts/rvm                       # Load RVM

    # For macOS users
    brew install openssl readline libyaml           # Install dependencies
    rvm install 3.2.2 --with-openssl-dir=$(brew --prefix openssl)

    # For Linux users
    rvm install 3.2.2

    # Create and use gemset
    rvm use 3.2.2@personal_blog --create
    ```

2. Install bundler:

    ```bash
    gem install bundler
    ```

3. Install dependencies:

    ```bash
    bundle install
    ```

4. Run the site:
    ```bash
    bundle exec jekyll serve --config _config.yml,_config_dev.yml --livereload
    ```

### Troubleshooting Ruby Installation

If you encounter issues with Ruby installation:

1. Try installing with the `--disable-binary` flag:

    ```bash
    rvm install 3.2.2 --disable-binary
    ```

2. Make sure you have the necessary dependencies:

    ```bash
    # For macOS
    brew install openssl readline libyaml
    ```

3. Specify OpenSSL path explicitly:
    ```bash
    rvm install 3.2.2 --with-openssl-dir=$(brew --prefix openssl)
    ```

### Testing changes before deployment

Any changes you make to the site files will automatically be reflected in the browser with live reloading. This allows you to preview your changes before committing and pushing to GitHub.

## Development Configuration

The site uses two configuration files:

-   `_config.yml` - Main configuration used in production
-   `_config_dev.yml` - Development overrides for local testing

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch using the GitHub Actions workflow defined in `.github/workflows/jekyll.yml`.

## License

See the LICENSE file for more information.
