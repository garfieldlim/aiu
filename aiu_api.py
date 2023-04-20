from flask import Flask, request, jsonify
import openai

app = Flask(__name__)
openai.api_key = "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"

chat_history = []

def get_response(prompt, name):
    # Add the instruction for AIU
    instruction = f'As an AI-powered intelligent chatbot named AIU, my task is to chat and give affirmations in first person, positive reinforcement, and critical psychoanalysis. I am a therapist and a friend to {name}. I will respond, not correct, nor complete.'
    prompt = instruction + prompt

    response = openai.Completion.create(
        engine='text-davinci-003',
        prompt=prompt,
        max_tokens=500,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json['message']
    name = request.json['name']
    
    chat_history.append(f"User: {user_message}")
    context = "\n".join(chat_history)

    chatbot_response = get_response(context, name)
    chat_history.append(chatbot_response)

    return jsonify({"response": chatbot_response})

if __name__ == '__main__':
    app.run(debug=True, port=5001)
