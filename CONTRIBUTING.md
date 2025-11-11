# Contributing to Mood Music App

First off, thank you for considering contributing to Mood Music App! 🎵😊

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

## How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Screenshots** if applicable
- **Environment details** (OS, Flutter version, device)

### Suggesting Enhancements 💡

Enhancement suggestions are welcome! Please provide:

- **Clear use case** - why is this enhancement useful?
- **Detailed description** of the proposed functionality
- **Mockups or examples** if applicable

### Pull Requests 🔀

1. **Fork the repository** and create your branch from `main`
2. **Follow the code style** - run `flutter format .` before committing
3. **Write clear commit messages** following conventional commits
4. **Test your changes** thoroughly
5. **Update documentation** if needed
6. **Submit a pull request** with a clear description

## Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/mel-adna/Mood-Music-App.git
   cd Mood-Music-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment**
   - Copy `.env.example` to `.env`
   - Add your Spotify API credentials
   - See `SETUP_GUIDE.md` for detailed instructions

4. **Run the app**
   ```bash
   flutter run
   ```

## Code Style Guidelines

- **Follow Dart style guide**: Use `flutter analyze` to check for issues
- **Format code**: Run `flutter format .` before committing
- **Meaningful names**: Use descriptive variable and function names
- **Comments**: Add comments for complex logic
- **Error handling**: Always handle potential errors gracefully

## Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(emotion): add support for compound emotions
fix(camera): resolve preview freeze on Android
docs(readme): update setup instructions
```

## Project Structure

```
lib/
├── config/         # Configuration and constants
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Business logic and API services
└── widgets/        # Reusable UI components
```

## Testing

- Write tests for new features
- Ensure existing tests pass: `flutter test`
- Test on multiple platforms when possible

## Need Help?

- Check existing [Issues](https://github.com/mel-adna/Mood-Music-App/issues)
- Review the [README.md](README.md) and [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Ask questions in issue discussions

## Recognition

Contributors will be recognized in the project README. Thank you for making Mood Music App better! 🙌

---

**Happy Coding!** 🚀
