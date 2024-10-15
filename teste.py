import pyttsx3

# Inicializar o mecanismo de conversão de texto em fala
engine = pyttsx3.init()

# Listar todas as vozes disponíveis
voices = engine.getProperty('voices')
for index, voice in enumerate(voices):
    print(f"Voice {index}: {voice.name} - {voice.id}")

# Escolher a voz desejada
voice_id = int(input("Escolha o número da voz que deseja usar: "))
engine.setProperty('voice', voices[voice_id].id)

# Ajustar a velocidade da fala
rate = engine.getProperty('rate')
engine.setProperty('rate', rate - 50)

# Função para falar
def speak(text):
    engine.say(text)
    engine.runAndWait()

# Testar a voz escolhida
speak("Esta é a voz escolhida. Espero que goste!")
