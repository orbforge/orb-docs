# 🔮 Orb Documentation 📑

This repository contains the official documentation for [Orb](https://orb.net), an intelligent network monitoring platform that continuously measures internet experience. The documentation is published at [orb.net/docs](https://orb.net/docs).

## Documentation Structure

The documentation is organized into several main sections:

- **Getting Started**: Introduction to Orb, quickstart guides, and basic concepts
- **Install Orb Apps**: Installation instructions for various platforms (iOS, Android, macOS, Windows)
- **Set Up an Orb Sensor**: Detailed guides for setting up dedicated sensors on multiple platforms
- **Using Orb Apps**: Comprehensive information about app interfaces, metrics, and account management

## Contributing to Documentation

We welcome contributions from the community to improve the Orb documentation. Here's how you can contribute:

### Prerequisites

- A GitHub account
- Basic knowledge of Markdown
- Familiarity with Git and GitHub pull request workflow

### How to Contribute

You can contribute in several ways:

- Edit directly on GitHub.com or GitHub.dev (click the pencil icon on any file)
- Clone the repo locally and use your preferred workflow
- Use GitHub Desktop or another Git client

When creating your pull request, please describe:

- What changes you've made
- Why these changes are helpful
- Any related issues or considerations

### Making Changes

- All documentation is written in Markdown
- Use the Frontmatter section for metadata at the top of each Markdown file
- Place images in the appropriate subdirectory within the `/images` folder, and linked using relative paths (e.g. `../../images/orb-app/link-account.png`). This ensures that images are displayed correctly on GitHub and on the published site.
- When linking to other documentation pages, use absolute links without domain (e.g. `/docs/install-orb/ios`)). This ensures that links work on GitHub and on the published site.
- Follow the existing structure and style of the documentation
- New documentation should be created in the appropriate section folder
- Scripts are welcome, see the `/scripts` directory for examples
- Add a link to the new documentation in the relevant section of the navigation.md file
- Run `./validate-links.py` to check for broken links or images in the documentation

### Scripts

- the `/scripts` directory contains scripts for installing & configuring Orb on various platforms. If you are adding a new script, please ensure it follows the same structure and is tested on the respective platform.

### Review Process

After you submit a pull request:

1. Maintainers will review your contribution
2. If changes are needed, the review will provide feedback
3. Once approved, your changes will be merged into the main repository
4. Your contribution will be published to the Orb documentation site

## Reporting issues with Orb

Issues with the Orb app, platform, and these docs should be reported in the [orb-issues repository](https://github.com/orbforge/orb-issues/issues).

## Contact

If you have questions that aren't addressed here, you can:

- Join our [Discord community](https://discord.gg/orbforge)
- Visit our [support page](https://orb.net/support)

Thank you for helping improve the Orb documentation!

## License

This documentation is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for details.
