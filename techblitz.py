import re
import gradio as gr
import requests

# Function to extract financial details
def extract_financial_details(input_text):
    # Regular expressions for extraction
    inflation_regex = re.search(r'inflation rate of (\d+\.?\d*)%', input_text)
    interest_rate_regex = re.search(r'interest rates (?:increasing|rising) by (\d+\.?\d*)%', input_text)
    duration_regex = re.search(r'next (\d+) months?', input_text)

    # Extract values if found
    inflation_rate = float(inflation_regex.group(1)) if inflation_regex else None
    interest_rate_change = float(interest_rate_regex.group(1)) if interest_rate_regex else None
    duration_months = int(duration_regex.group(1)) if duration_regex else None

    # Check if all values are extracted
    if None in (inflation_rate, interest_rate_change, duration_months):
        return "Error: Could not extract necessary financial details."

    # Generate enhanced prompt for Groq AI
    final_prompt = (
    f"Generate a detailed financial analysis report for the next {duration_months} months. "
    f"Analyze economic trends, inflation impact, and interest rate changes, assuming an inflation rate of {inflation_rate}% "
    f"and interest rates rising by {interest_rate_change}%. Provide insights on risk management strategies and "
    f"investment recommendations for stable long-term returns. "
    f"Format the output strictly as follows:\n\n"
    f"Market Trends:\n- Key economic trends\n- Sector performance\n- Inflation effects\n\n"
    f"Interest Rate Impact:\n- Effect on borrowing\n- Investment risks\n- Corporate profits\n\n"
    f"Investment Recommendations:\n- Best sectors to invest\n- Safe assets during inflation\n- Strategies for long-term returns\n\n"
    f"Risk Management:\n- Major financial risks\n- Mitigation strategies\n- Alternative financial options"
)


    # Send request to Groq AI
    response = send_to_groq(final_prompt)

    return response

# Function to send request to Groq AI API
def send_to_groq(prompt):
    GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions"  # Replace with the actual Groq API URL
    GROQ_API_KEY = "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"  # Replace with your actual API key

    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "gemma2-9b-it",  # Specify the model
        "messages": [
            {"role": "system", "content": "You are a financial analysis AI that provides detailed reports."},
            {"role": "user", "content": prompt}
        ],
        "max_tokens": 500  # Adjust as needed
    }

    response = requests.post(GROQ_API_URL, headers=headers, json=payload)

    if response.status_code == 200:
        return response.json()["choices"][0]["message"]["content"]
    else:
        return f"Error: {response.status_code}, {response.text}"

# Gradio Interface
iface = gr.Interface(
    fn=extract_financial_details,
    inputs="text",
    outputs="text",
    title="Financial Analysis AI",
    description="Enter your financial analysis request. The system will extract key details, send the query to Groq AI, and generate a report."
)

iface.launch()
