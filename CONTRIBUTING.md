# Contributing to CI/CD Microservices Project

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Maintain professional communication

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, versions, etc.)
   - Screenshots if applicable

### Suggesting Features

1. Check if the feature has been suggested
2. Create an issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach

### Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/cicd-microservices-project.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow coding standards
   - Write tests for new features
   - Update documentation

4. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature"
   ```
   
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `style:` Code style changes
   - `refactor:` Code refactoring
   - `test:` Test changes
   - `chore:` Build/tooling changes

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Provide clear description
   - Reference related issues
   - Ensure all checks pass

## Development Guidelines

### Backend (.NET)

- Follow C# coding conventions
- Use async/await for I/O operations
- Add XML documentation for public APIs
- Write unit tests with xUnit
- Maintain test coverage above 80%

### Frontend (React)

- Use functional components with hooks
- Follow React best practices
- Use TypeScript for type safety (if applicable)
- Write component tests
- Ensure accessibility (a11y)

### Docker

- Use multi-stage builds
- Minimize image size
- Run as non-root user
- Use specific version tags

### Kubernetes

- Follow Kubernetes best practices
- Set resource limits and requests
- Use health checks
- Document configuration changes

### CI/CD

- Ensure all tests pass
- Fix security vulnerabilities
- Update documentation
- Test in staging before production

## Testing

### Run Backend Tests
```bash
cd backend
dotnet test
```

### Run Frontend Tests
```bash
cd frontend
npm test
```

### Run Integration Tests
```bash
docker-compose up -d
# Run your integration tests
docker-compose down
```

## Documentation

- Update README.md for user-facing changes
- Update architecture.md for design changes
- Update deployment-guide.md for deployment changes
- Add inline comments for complex logic
- Update API documentation (Swagger)

## Review Process

1. Automated checks must pass
2. Code review by maintainers
3. Address review feedback
4. Approval from at least one maintainer
5. Merge to main branch

## Getting Help

- Check documentation in `/docs`
- Search existing issues
- Ask questions in discussions
- Join our community chat (if available)

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing! 🎉
