# AI Agent Debate System

A multi-agent debate system based on the AutoGen framework, supporting structured debates on custom topics.

[中文版](README.md)

## Features

- Custom debate topics
- Multi-agent interaction (Supporter, Opponent, Judge)
- Structured debate process
- Automatic debate recording
- Support for custom LLM and OpenAI API
- Chinese language interface

## Requirements

- Python 3.9+
- OpenAI API key
- (Optional) Custom LLM API configuration

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/AI-Agent-Debate_Autogen_Turtorial.git
cd AI-Agent-Debate_Autogen_Turtorial
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Configure environment variables:
```bash
cp .env.sample .env
```
Then edit the .env file with your API keys and configuration.

## Usage

1. Start the program:
```bash
python main.py
```

2. Follow the prompts to input:
   - Debate topic
   - Maximum debate rounds
   - System messages for both sides
   - Descriptions for both sides

3. Watch the debate:
   - The program will automatically conduct the debate
   - The judge will moderate and guide the discussion
   - A winner will be announced at the end

4. View results:
   - Debate records are automatically saved in the debates directory
   - Includes both JSON format complete records and readable text records

## Configuration

### Environment Variables

- `OPENAI_API_KEY`: OpenAI API key
- `CUSTOM_LLM_API_KEY`: Custom LLM API key
- `CUSTOM_LLM_API_BASE`: Custom LLM API base URL
- `CUSTOM_LLM_MODEL`: Custom LLM model name

### Custom Settings

- Modify system messages in main.py to customize agent behavior
- Adjust maximum debate rounds
- Customize saved information format

## Project Structure

```
.
├── main.py              # Main program
├── requirements.txt     # Dependencies list
├── .env.sample         # Environment variables template
├── .gitignore          # Git ignore configuration
├── README.md           # Chinese documentation
├── README_en.md        # English documentation
└── debates/            # Debate records directory
```

## Important Notes

- Ensure API key security
- Recommended to use virtual environment
- Debate records will use disk space, clean periodically
- Check network connection and key validity if API errors occur

## Contributing

Welcome to submit Issues and Pull Requests to improve the project. Before submitting code, please ensure:

1. Code follows Python coding standards
2. Necessary comments are added
3. Documentation is updated
4. Tests pass

## License

MIT License

## Contact

For questions or suggestions, please submit an Issue or contact the project maintainer.
