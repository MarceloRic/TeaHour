import time as tm
import os
import json
import threading
import pyttsx3
import speech_recognition as sr

# Inicializar o mecanismo de conversão de texto em fala
engine = pyttsx3.init()

# Definir a voz escolhida (voz 74)
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[74].id)

# Ajustar a velocidade da fala
rate = engine.getProperty('rate')
engine.setProperty('rate', rate - 50)  # Ajuste a velocidade conforme necessário

def speak(text):
    engine.say(text)
    engine.runAndWait()

# Inicializar o reconhecimento de voz uma vez
recognizer = sr.Recognizer()
microphone = sr.Microphone()

def listen():
    with microphone as source:
        print("Listening...")
        audio = recognizer.listen(source)
        try:
            command = recognizer.recognize_google(audio)
            print(f"You said: {command}")
            return command
        except sr.UnknownValueError:
            print("Sorry, I did not understand that.")
            return ""
        except sr.RequestError:
            print("Could not request results; check your network connection.")
            return ""
        
# Funções para carregar e salvar o histórico de chá
historico = []

def salvar_historico(preparacao):
    historico.append(preparacao)

def mostrar_historico():
    if historico:
        print("\nHistórico de Preparações de Chá:")
        for i, preparacao in enumerate(historico, 1):
            print(f"\nPreparação {i}:")
            print(f"Chá Escolhido: {preparacao['cha_escolhido']}")
            print(f"Acompanhamento Escolhido: {preparacao['acomp_escolhido']}")
            print(f"Modo de Preparo: {' '.join(preparacao['modo_preparo'])}")
            print(f"Curiosidade: {preparacao['curiosidade']}")
    else:
        print("Nenhum histórico de preparações de chá disponível.")



# Lista ampliada de tipos de chá
tipos_de_cha = [
    "Chá preto",
    "Chá verde",
    "Chá de camomila",
    "Chá de hortelã",
    "Chá de gengibre",
    "Chá de hibisco",
    "Chá de erva-doce",
    "Chá de jasmim",
    "Chá de limão",
    "Chá de canela",
    "Chá de frutas vermelhas",
    "Chá de maçã e canela",
    "Chá de rooibos",
    "Chá de erva-mate",
    "Chá de oolong",
    "Chá de echinacea",
    "Chá de hibisco e rosas",
    "Chá de capim-cidreira",
    "Chá branco",
    "Chá de maracujá",
    "Chá de menta",
    "Chá de verbena",
    "Chá de lavanda",
    "Chá de limão e mel",
    "Chá chai",
    "Chá matcha",
    "Chá de romã",
    "Chá de cranberry",
    "Chá de dente-de-leão",
    "Chá de hortelã-pimenta",
    "Chá de ginseng",
    "Chá de alcaçuz",
    "Chá de anis",
    "Chá de cúrcuma",
    "Chá de cardamomo",
    "Chá de cravo",
    "Chá de boldo",
    "Chá de tília",
    "Chá de erva-cidreira",
    "Chá de goiabeira",
    "Chá de mangueira",
    "Chá de hortênsia",
    "Chá de lúpulo",
    "Chá de moringa",
    "Chá de urtiga",
    "Chá de sálvia",
    "Chá de tomilho",
    "Chá de louro",
    "Chá de alecrim",
    "Chá de eucalipto"
]

# Lista ampliada de acompanhamentos
acompanhamentos_cha = [
    "Bolachas de aveia",
    "Pão de mel",
    "Biscoitos de gengibre",
    "Muffins de mirtilo",
    "Pão de queijo",
    "Fatias de bolo de laranja",
    "Scones com geleia",
    "Torradas com manteiga",
    "Biscoitos amanteigados",
    "Fatias de bolo (fubá, cenoura, limão)",
    "Tartes de frutas",
    "Fatias de pão integral com mel",
    "Croissants",
    "Cookies de chocolate",
    "Pães de frutas",
    "Sanduíches de pepino",
    "Bolinho de chuva",
    "Madeleines",
    "Brownies",
    "Pastéis de nata",
    "Torta de maçã",
    "Fatias de pão de banana",
    "Torta de noz-pecã",
    "Muffins de amora",
    "Pão de nozes",
    "Sanduíches de salmão",
    "Pãezinhos doces",
    "Donuts",
    "Barrinhas de cereais",
    "Mini croissants recheados",
    "Churros",
    "Waffles",
    "Panquecas",
    "Brioche",
    "Fatias de torta de limão",
    "Cookies de aveia e passas",
    "Cheesecake",
    "Mousse de chocolate",
    "Pão de abóbora",
    "Fatias de quiche",
    "Torta de frango",
    "Empanadas",
    "Palmiers",
    "Bolo de rolo",
    "Pão de leite",
    "Brioche com chocolate",
    "Biscoitos de amêndoa",
    "Pães de batata",
    "Strudel de maçã",
    "Tartelette de frutas"
]

# Lista de recomendações de livros
recomendacoes_livros = [
    "Chá preto e Bolachas de aveia: '1984' de George Orwell",
    "Chá verde e Pão de mel: 'Orgulho e Preconceito' de Jane Austen",
    "Chá de camomila e Biscoitos de gengibre: 'O Morro dos Ventos Uivantes' de Emily Brontë",
    "Chá de hortelã e Muffins de mirtilo: 'Para Sempre Alice' de Lisa Genova",
    "Chá de gengibre e Pão de queijo: 'A Revolução dos Bichos' de George Orwell",
    "Chá de hibisco e Fatias de bolo de laranja: 'A Menina que Roubava Livros' de Markus Zusak",
    "Chá de erva-doce e Scones com geleia: 'O Sol é para Todos' de Harper Lee",
    "Chá de jasmim e Torradas com manteiga: 'Cem Anos de Solidão' de Gabriel García Márquez",
    "Chá de limão e Biscoitos amanteigados: 'O Pequeno Príncipe' de Antoine de Saint-Exupéry",
    "Chá de canela e Fatias de bolo (fubá, cenoura, limão): 'Alice no País das Maravilhas' de Lewis Carroll",
    "Chá de frutas vermelhas e Tartes de frutas: 'Mulherzinhas' de Louisa May Alcott",
    "Chá de maçã e canela e Fatias de pão integral com mel: 'Os Miseráveis' de Victor Hugo",
    "Chá de rooibos e Croissants: 'O Alquimista' de Paulo Coelho",
    "Chá de erva-mate e Cookies de chocolate: 'Dom Quixote' de Miguel de Cervantes",
    "Chá de oolong e Pães de frutas: 'O Conde de Monte Cristo' de Alexandre Dumas",
    "Chá de echinacea e Sanduíches de pepino: 'Moby Dick' de Herman Melville",
    "Chá de hibisco e rosas e Bolinho de chuva: 'A Ilha do Tesouro' de Robert Louis Stevenson",
    "Chá de capim-cidreira e Madeleines: 'Jane Eyre' de Charlotte Brontë",
    "Chá branco e Brownies: 'Fahrenheit 451' de Ray Bradbury",
    "Chá de maracujá e Pastéis de nata: 'O Grande Gatsby' de F. Scott Fitzgerald",
    "Chá de menta e Torta de maçã: 'As Aventuras de Sherlock Holmes' de Arthur Conan Doyle",
    "Chá de verbena e Fatias de pão de banana: 'O Jardim Secreto' de Frances Hodgson Burnett",
    "Chá de lavanda e Torta de noz-pecã: 'Pride and Prejudice' de Jane Austen",
    "Chá de limão e mel e Muffins de amora: 'A Pequena Sereia' de Hans Christian Andersen",
    "Chá de maracujá e Pão de nozes: 'O Sol Também Se Levanta' de Ernest Hemingway",
    "Chá chai e Sanduíches de salmão: 'As Brumas de Avalon' de Marion Zimmer Bradley",
    "Chá matcha e Pãezinhos doces: 'Memórias de uma Gueixa' de Arthur Golden",
    "Chá de romã e Donuts: 'O Apanhador no Campo de Centeio' de J.D. Salinger",
    "Chá de cranberry e Barrinhas de cereais: 'A Lista de Schindler' de Thomas Keneally",
    "Chá de dente-de-leão e Mini croissants recheados: 'O Senhor dos Anéis' de J.R.R. Tolkien",
    "Chá de hortelã-pimenta e Churros: 'A Vida Secreta das Abelhas' de Sue Monk Kidd",
    "Chá de ginseng e Waffles: 'Os Contos de Beedle, o Bardo' de J.K. Rowling",
    "Chá de alcaçuz e Panquecas: 'A Roda do Tempo' de Robert Jordan",
    "Chá de anis e Brioche: 'Os Três Mosqueteiros' de Alexandre Dumas",
    "Chá de cúrcuma e Fatias de torta de limão: 'O Nome do Vento' de Patrick Rothfuss",
    "Chá de cardamomo e Cookies de aveia e passas: 'O Castelo Animado' de Diana Wynne Jones",
    "Chá de cravo e Cheesecake: 'O Perfume' de Patrick Süskind",
    "Chá de boldo e Mousse de chocolate: 'O Silmarillion' de J.R.R. Tolkien",
    "Chá de tília e Pão de abóbora: 'Contos de Fadas' de Hans Christian Andersen",
    "Chá de erva-cidreira e Fatias de quiche: 'O Hobbit' de J.R.R. Tolkien",
    "Chá de goiabeira e Torta de frango: 'A Sombra do Vento' de Carlos Ruiz Zafón",
    "Chá de mangueira e Empanadas: 'A Fúria dos Reis' de George R.R. Martin",
    "Chá de hortênsia e Palmiers: 'Os Pilares da Terra' de Ken Follett",
    "Chá de lúpulo e Bolo de rolo: 'A Arte da Guerra' de Sun Tzu",
    "Chá de moringa e Pão de leite: 'O Mundo de Sofia' de Jostein Gaarder",
    "Chá de urtiga e Brioche com chocolate: 'A Revolução dos Bichos' de George Orwell",
    "Chá de sálvia e Biscoitos de amêndoa: 'O Conde de Monte Cristo' de Alexandre Dumas",
    "Chá de tomilho e Pães de batata: 'O Código Da Vinci' de Dan Brown",
    "Chá de louro e Strudel de maçã: 'O Cemitério de Praga' de Umberto Eco",
    "Chá de alecrim e Tartelette de frutas: 'Os Três Mosqueteiros' de Alexandre Dumas",
    "Chá de eucalipto e Barrinhas de cereais: 'O Nome da Rosa' de Umberto Eco"
]

curiosidades_cha = {
    "Chá preto": "O chá preto é totalmente oxidado, o que lhe dá uma cor escura e sabor robusto.",
    "Chá verde": "O chá verde é conhecido por seus antioxidantes e é minimamente oxidado.",
    "Chá de camomila": "O chá de camomila é famoso por suas propriedades calmantes e pode ajudar a melhorar o sono.",
    "Chá de hortelã": "O chá de hortelã pode ajudar na digestão e aliviar dores de estômago.",
    "Chá de gengibre": "O chá de gengibre é conhecido por suas propriedades anti-inflamatórias e ajuda no combate a náuseas.",
    "Chá de hibisco": "O chá de hibisco é rico em vitamina C e pode ajudar a reduzir a pressão arterial.",
    "Chá de erva-doce": "O chá de erva-doce pode ajudar a aliviar cólicas e melhorar a digestão.",
    "Chá de jasmim": "O chá de jasmim é muitas vezes misturado com chá verde e é conhecido por seu aroma floral.",
    "Chá de limão": "O chá de limão é refrescante e pode ajudar a fortalecer o sistema imunológico.",
    "Chá de canela": "O chá de canela tem propriedades antimicrobianas e pode ajudar a regular o açúcar no sangue.",
    "Chá de frutas vermelhas": "O chá de frutas vermelhas é rico em antioxidantes e tem um sabor deliciosamente frutado.",
    "Chá de maçã e canela": "O chá de maçã e canela combina o doce da maçã com o calor da canela, perfeito para dias frios.",
    "Chá de rooibos": "O chá de rooibos é naturalmente sem cafeína e conhecido por suas propriedades antioxidantes.",
    "Chá de erva-mate": "O chá de erva-mate é um estimulante natural e é muito popular na América do Sul.",
    "Chá de oolong": "O chá de oolong é parcialmente oxidado, situando-se entre o chá verde e o chá preto em termos de sabor.",
    "Chá de echinacea": "O chá de echinacea pode ajudar a fortalecer o sistema imunológico e prevenir resfriados.",
    "Chá de hibisco e rosas": "O chá de hibisco e rosas combina os benefícios do hibisco com o aroma delicado das rosas.",
    "Chá de capim-cidreira": "O chá de capim-cidreira é conhecido por suas propriedades calmantes e pode ajudar a aliviar o estresse.",
    "Chá branco": "O chá branco é minimamente processado, preservando muitos de seus antioxidantes naturais.",
    "Chá de maracujá": "O chá de maracujá pode ajudar a promover o relaxamento e melhorar o sono.",
    "Chá de menta": "O chá de menta é conhecido por suas propriedades refrescantes e digestivas.",
    "Chá de verbena": "O chá de verbena é usado para aliviar a tensão e ajudar no sono.",
    "Chá de lavanda": "O chá de lavanda é calmante e pode ajudar a reduzir a ansiedade.",
    "Chá de limão e mel": "O chá de limão e mel é ótimo para aliviar dores de garganta e resfriados.",
    "Chá chai": "O chá chai é uma mistura picante de chá preto com especiarias como canela, cardamomo e gengibre.",
    "Chá matcha": "O chá matcha é um chá verde em pó usado tradicionalmente na cerimônia do chá japonesa.",
    "Chá de romã": "O chá de romã é rico em antioxidantes e tem um sabor doce e refrescante.",
    "Chá de cranberry": "O chá de cranberry pode ajudar na saúde do trato urinário.",
    "Chá de dente-de-leão": "O chá de dente-de-leão pode ajudar na desintoxicação do fígado.",
    "Chá de hortelã-pimenta": "O chá de hortelã-pimenta é refrescante e pode ajudar a aliviar dores de cabeça.",
    "Chá de ginseng": "O chá de ginseng é usado para aumentar a energia e reduzir o estresse.",
    "Chá de alcaçuz": "O chá de alcaçuz pode ajudar a aliviar problemas respiratórios.",
    "Chá de anis": "O chá de anis tem um sabor doce e pode ajudar na digestão.",
    "Chá de cúrcuma": "O chá de cúrcuma tem propriedades anti-inflamatórias.",
    "Chá de cardamomo": "O chá de cardamomo é aromático e pode ajudar na digestão.",
    "Chá de cravo": "O chá de cravo é conhecido por suas propriedades antimicrobianas.",
    "Chá de boldo": "O chá de boldo é tradicionalmente usado para problemas digestivos.",
    "Chá de tília": "O chá de tília é calmante e pode ajudar no sono.",
    "Chá de erva-cidreira": "O chá de erva-cidreira é calmante e pode ajudar a aliviar a ansiedade.",
    "Chá de goiabeira": "O chá de goiabeira pode ajudar a tratar diarreias.",
    "Chá de mangueira": "O chá de mangueira é usado para suas propriedades antioxidantes.",
    "Chá de hortênsia": "O chá de hortênsia é conhecido por suas propriedades diuréticas.",
    "Chá de lúpulo": "O chá de lúpulo é usado para tratar insônia e ansiedade.",
    "Chá de moringa": "O chá de moringa é rico em vitaminas e minerais.",
    "Chá de urtiga": "O chá de urtiga pode ajudar na saúde dos ossos e pele.",
    "Chá de sálvia": "O chá de sálvia pode ajudar a melhorar a memória.",
    "Chá de tomilho": "O chá de tomilho é usado para aliviar tosse e resfriados.",
    "Chá de louro": "O chá de louro pode ajudar na digestão.",
    "Chá de alecrim": "O chá de alecrim é energizante e pode ajudar na circulação.",
    "Chá de eucalipto": "O chá de eucalipto é conhecido por suas propriedades respiratórias."
}


# Apresentação dos tipos de chá
print("Tipos de chá disponíveis:")
for i, cha in enumerate(tipos_de_cha):
    print(f"{i + 1} - {cha}")

# Escolha do usuário para o tipo de chá
speak("Escolha o número do chá que deseja.")
escolha_1 = int(input("Escolha o número do chá que deseja: ")) - 1

# Validação da escolha do tipo de chá
if 0 <= escolha_1 < len(tipos_de_cha):
    cha_escolhido = tipos_de_cha[escolha_1]
    speak(f"Você escolheu: {cha_escolhido}")
    print(f"\nVocê escolheu: {cha_escolhido}")
else:
    speak("Escolha inválida, tente novamente.")
    print("Escolha inválida, tente novamente.")
    exit()

# Apresentação dos acompanhamentos
print("Sugestões de acompanhamentos para o cházinho:")
for i, item in enumerate(acompanhamentos_cha):
    print(f"{i + 1} - {item}")

# Escolha do usuário para o acompanhamento
speak("Escolha o número do acompanhamento que deseja.")
escolha_2 = int(input("Escolha o número do acompanhamento que deseja: ")) - 1

# Validação da escolha do acompanhamento
if 0 <= escolha_2 < len(acompanhamentos_cha):
    acomp_escolhido = acompanhamentos_cha[escolha_2]
    speak(f"Você escolheu: {acomp_escolhido}")
    print(f"\nSeu acompanhamento: {acomp_escolhido}")
else:
    speak("Escolha inválida, sem acompanhamentos.")
    print("Escolha inválida, sem acompanhamentos.")
    exit()



# Receita de chá, mini app
cha = []
print(f"\nVamos fazer esse {cha_escolhido}...")

ask_0 = str(input("\nQual temperatura você deseja? ")).lower()
ask_1 = str(input("1 - Você quer ferver o chá? (s/n): ")).lower()
ask_e1 = str(input("Vamos ferver por quanto tempo? ")).lower()
ask_2 = str(input("2 - Vamos colocar o chá na xícara? (s/n): ")).lower()
ask_3 = str(input("3 - Agora vamos despejar a água na xícara? (s/n): ")).lower()

print("-- Agora espere uns segundinhos...")
tm.sleep(4)

ask_5 = str(input("4 - Quer adicionar leite ou açúcar? (l/a), (tudo): ")).lower()
ask_6 = str(input("5 - Agora vamos mexer isso? (s/n): ")).lower()

# Interação com o usuário
if ask_0:
    cha.append(f"Temperatura escolhida: {ask_0} graus.")
else:
    print("Nenhuma temperatura específica...")

if ask_1 == "s":
    cha.append("1 - Chá Quentinho")
else:
    cha.append("1 - Tudo bem, chá gelado!")

if ask_2 == "s":
    cha.append("2 - Colocando o chá na xícara.")
else:
    cha.append("2 - Então melhor num copo? Tudo bem.")

if ask_3 == "s":
    cha.append(f"3 - Agora jogamos a água na xícara com {cha_escolhido}...")
else:
    cha.append(f"3 - Jogamos no copo então, né? Sem problemas, usando {cha_escolhido}.")

if ask_e1:
    cha.append(f"Fervendo por {ask_e1} minutinhos...")
    tm.sleep(3)
else:
    print("Nenhum tempo específico...")

if ask_5 == "l":
    cha.append("4 - Estilo inglês, adorei!")
elif ask_5 == "a":
    cha.append("4 - Bem docinho, que delícia!")
elif ask_5 == "tudo":
    cha.append("4 - Chá completinho? Pode deixar!")
else:
    cha.append("4 - Escolha inválida, sem adições.")

if ask_6 == "s":
    cha.append("5 - Bem mexidinho! ")
    tm.sleep(2)
else:
    cha.append("5 - Beleza, então deixa assim.")

print(f"\nSeu {cha_escolhido} está prontinho, e seu acompanhamento: ({acomp_escolhido}), está servido.")
curiosidade = curiosidades_cha.get(cha_escolhido, "Nenhuma curiosidade disponível para este chá.")
print(f"Curiosidade: {curiosidade}")
print(f"\nModo de preparo do seu chá:\n\n{cha}\n\nEspero que goste! Bom apetite.")


# Função para carregar os comentários de um arquivo
def carregar_comentarios():
    if os.path.exists("comentarios.json"):
        with open("comentarios.json", "r") as file:
            return json.load(file)
    return []

# Função para salvar os comentários em um arquivo
def salvar_comentarios(comentarios):
    with open("comentarios.json", "w") as file:
        json.dump(comentarios, file)

tm.sleep(8)

# Carregar comentários existentes
comentarios = carregar_comentarios()

# Adição de comentários
speak("Você gostaria de deixar um comentário sobre seu chá?")
print("Você gostaria de deixar um comentário sobre seu chá? (s/n): ")
comentar = input().lower()

if comentar == 's':
    speak("Digite seu comentário.")
    print("Digite seu comentário: ")
    comentario = input()
    comentarios.append(comentario)
    speak("Obrigado pelo seu comentário!")
    print("\nObrigado pelo seu comentário!")

# Salvar os comentários
salvar_comentarios(comentarios)

# Mostrar todos os comentários
if comentarios:
    speak("Aqui estão os comentários dos usuários:")
    print("\nComentários dos usuários:")
    for comentario in comentarios:
        print(f"- {comentario}")


# Recomendações de livros
for recomendacao in recomendacoes_livros:
    cha_comb, livro = recomendacao.split(": ")
    partes = cha_comb.split(" e ")
    if len(partes) == 2:
        cha_tipo, acomp_tipo = partes
        if cha_escolhido.strip() == cha_tipo.strip() and acomp_escolhido.strip() == acomp_tipo.strip():
            print(f"\nRecomendação de livro: {livro}")
            break
else:
    print("\nNenhuma recomendação de livro encontrada para esta combinação.")

# Salvar a preparação atual no histórico
preparacao_atual = {
    "cha_escolhido": cha_escolhido,
    "acomp_escolhido": acomp_escolhido,
    "modo_preparo": cha,
    "curiosidade": curiosidades_cha.get(cha_escolhido, "Nenhuma curiosidade disponível para este chá.")
}
salvar_historico(preparacao_atual)

# Perguntar ao usuário se deseja ver o histórico de preparos
ver_historico = input("Você deseja ver o histórico de preparos? (s/n): ").strip().lower()
if ver_historico == "s":
    mostrar_historico()
else:
    print("Encerrando o programa. Até a próxima!")