import time as tm
import os
import json
import pyttsx3
import speech_recognition as sr
import pyaudio

# Função para carregar XP e nível de um arquivo JSON
def carregar_xp_nivel():
    if os.path.exists("xp_nivel.json"):
        with open("xp_nivel.json", "r") as file:
            try:
                return json.load(file)
            except json.JSONDecodeError:
                return {"xp": 0, "nivel": 1}
    return {"xp": 0, "nivel": 1}

# Função para salvar XP e nível em um arquivo JSON
def salvar_xp_nivel(xp, nivel):
    dados_xp_nivel = {
        "xp": xp,
        "nivel": nivel
    }
    with open("xp_nivel.json", "w") as file:
        json.dump(dados_xp_nivel, file)


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


# Listas
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
    "Tartelette de frutas"]

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

# Listas Secretas com Valores de Desbloqueio
chas_secretos_valores = [
    ("Chá de laranja e maracujá", 50),
    ("Chá de morango e kiwi", 60),
    ("Chá de mirtilo e açaí", 70),
    ("Chá de pêssego e manga", 80),
    ("Chá de lichia e limão", 90),
    ("Chá de coco e baunilha", 100),
    ("Chá de goiaba e hibisco", 110),
    ("Chá de abacaxi e hortelã", 120),
    ("Chá de cereja e romã", 130),
    ("Chá de framboesa e lavanda", 140),
    ("Chá de capim-santo e gengibre", 150),
    ("Chá de amora e hibisco", 160),
    ("Chá de framboesa e limão", 170),
    ("Chá de laranja e canela", 180),
    ("Chá de pêra e especiarias", 190)
    ]

acompanhamentos_secretos_valores = [
("Trufas de chocolate", 50),
    ("Macarons", 60),
    ("Pão de mel com nozes", 70),
    ("Biscoitos de canela e gengibre", 80),
    ("Brownies de caramelo salgado", 90),
    ("Fatias de torta de frutas vermelhas", 100),
    ("Mini pavlovas", 110),
    ("Muffins de banana e aveia", 120),
    ("Cupcakes de baunilha", 130),
    ("Pão de ló de amêndoas", 140),
    ("Tartes de limão", 150),
    ("Bolinhos de chuva recheados", 160),
    ("Biscoitos de amêndoa com mel", 170),
    ("Pastéis de nata com frutas", 180),
    ("Mini cheesecakes", 190)
    ]

# Listas de Chás e Acompanhamentos Secretos Desbloqueados
chas_secretos_desbloqueados = []
acompanhamentos_secretos_desbloqueados = []
pontos = 0

# Função para carregar os pontos de um arquivo JSON
def carregar_pontos():
    if os.path.exists("pontos.json"):
        with open("pontos.json", "r") as file:
            return json.load(file)
    return 0

# Função para salvar os pontos em um arquivo JSON
def salvar_pontos(pontos):
    with open("pontos.json", "w") as file:
        json.dump(pontos, file)

# Função para carregar as conquistas secretas de um arquivo JSON
def carregar_conquistas_secretas():
    if os.path.exists("conquistas_secretas.json"):
        with open("conquistas_secretas.json", "r") as file:
            try:
                return json.load(file)
            except json.JSONDecodeError:
                return {"chas_secretos_desbloqueados": [], "acompanhamentos_secretos_desbloqueados": []}
    return {"chas_secretos_desbloqueados": [], "acompanhamentos_secretos_desbloqueados": []}

# Carregar XP e nível existentes
xp_nivel = carregar_xp_nivel()
xp = xp_nivel["xp"]
nivel = xp_nivel["nivel"]

# Função para atualizar XP e nível
def atualizar_xp_nivel(xp_atual, xp_ganho, nivel_atual):
    xp_atual += xp_ganho
    if xp_atual >= nivel_atual * 100:
        nivel_atual += 1
        xp_atual = 0  # Reset XP ao subir de nível
        print(f"Parabéns! Você subiu para o nível {nivel_atual}!")
    return xp_atual, nivel_atual


# Função para salvar as conquistas secretas em um arquivo JSON
def salvar_conquistas_secretas(chas_secretos_desbloqueados, acompanhamentos_secretos_desbloqueados):
    conquistas_secretas = {
        "chas_secretos_desbloqueados": chas_secretos_desbloqueados,
        "acompanhamentos_secretos_desbloqueados": acompanhamentos_secretos_desbloqueados
    }
    with open("conquistas_secretas.json", "w") as file:
        json.dump(conquistas_secretas, file)

# Função para exibir listas secretas
def exibir_listas_secretas():
    print("\nChás secretos desbloqueados:")
    if chas_secretos_desbloqueados:
        for cha in chas_secretos_desbloqueados:
            print(f"- {cha}")
    else:
        print("Nenhum chá secreto desbloqueado.")

    print("\nAcompanhamentos secretos desbloqueados:")
    if acompanhamentos_secretos_desbloqueados:
        for acomp in acompanhamentos_secretos_desbloqueados:
            print(f"- {acomp}")
    else:
        print("Nenhum acompanhamento secreto desbloqueado.")

# Carregar conquistas secretas existentes
conquistas_secretas = carregar_conquistas_secretas()
chas_secretos_desbloqueados = conquistas_secretas["chas_secretos_desbloqueados"]
acompanhamentos_secretos_desbloqueados = conquistas_secretas["acompanhamentos_secretos_desbloqueados"]

# Carregar pontos existentes
pontos = carregar_pontos()

# Perguntar ao usuário se deseja acessar os itens secretos
def escolher_lista():
    escolha = input("Você deseja acessar as listas secretas? (s/n): ").strip().lower()
    if escolha == "s":
        return True
    return False

# Escolher e exibir listas secretas
if escolher_lista():
    print("\nAcessando listas secretas...")
    exibir_listas_secretas()
    tipos_de_cha = chas_secretos_desbloqueados
    acompanhamentos_cha = acompanhamentos_secretos_desbloqueados
else:
    print("\nUsando listas normais...")

# Apresentação dos tipos de chá
print("Tipos de chá disponíveis:")
for i, cha in enumerate(tipos_de_cha):
    print(f"{i + 1} - {cha}")

# Escolha do usuário para o tipo de chá
speak("Olá! o que vai ser hoje?")
escolha_1 = int(input("Escolha o número do chá que deseja: ")) - 1

# Validação da escolha do tipo de chá
if 0 <= escolha_1 < len(tipos_de_cha):
    cha_escolhido = tipos_de_cha[escolha_1]
    speak(f"{cha_escolhido} que ótima escolha!")
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
speak("De acompanhmento vamos de que?")
escolha_2 = int(input("Escolha o número do acompanhamento que deseja: ")) - 1

# Validação da escolha do acompanhamento
if 0 <= escolha_2 < len(acompanhamentos_cha):
    acomp_escolhido = acompanhamentos_cha[escolha_2]
    speak(f"Que boa escolha: {acomp_escolhido} vai ficar incrível!")
    print(f"\nSeu acompanhamento: {acomp_escolhido}")
else:
    speak("Escolha inválida, sem acompanhamentos.")
    print("Escolha inválida, sem acompanhamentos.")
    exit()

# Receita de chá, mini app
cha = []
print(f"\nVamos fazer esse {cha_escolhido}...")

ask_0 = str(input("\nQual temperatura você deseja? ")).lower()
ask_1 = str(input("1 - Você quer ferver o chá ou deixar em infusão? (f/i): ")).lower()
ask_e1 = str(input("E por quanto tempo? ")).lower()
ask_2 = str(input("2 - Vamos colocar o chá na xícara ou na caneca? (x/cn): ")).lower()
ask_3 = str(input("3 - Agora vamos despejar a água na xícara/caneca ou servir gelado? (q/g): ")).lower()

print("-- Agora espere um pouquinho...")

tm.sleep(4)

ask_5 = str(input("4 - Quer adicionar leite, açúcar, mel ou tudo? (l/a/m/t): ")).lower()
ask_6 = str(input("5 - Agora vamos mexer isso com uma colher de chá, canudo ou palito? (c/ca/p): ")).lower()
ask_7 = str(input("6 - Vamos adicionar um toque especial? leite, hortelã, gengibre (l/h/g/nada): ")).lower()
ask_8 = str(input("7 - Quer um acompanhamento musical? (s/n): ")).lower()

# Interação com o usuário
if ask_0:
    cha.append(f"Temperatura escolhida: {ask_0} graus.")
else:
    print("Nenhuma temperatura específica...")

if ask_1 == "f":
    cha.append("1 - Chá Quentinho fervido.")
elif ask_1 == "i":
    cha.append("1 - Chá preparado por infusão.")
else:
    cha.append("1 - Método de preparo não escolhido corretamente.")

if ask_e1:
    cha.append(f"Tempo de preparo: {ask_e1} minutinhos.")
    tm.sleep(3)
else:
    print("Nenhum tempo específico...")

if ask_2 == "x":
    cha.append("2 - Colocando o chá na xícara.")
elif ask_2 == "cn":
    cha.append("2 - Colocando o chá na caneca.")
else:
    cha.append("2 - Recipiente de servir não escolhido corretamente.")

if ask_3 == "q":
    cha.append(f"3 - Agora jogamos a água na xícara com {cha_escolhido} quente.")
elif ask_3 == "g":
    cha.append(f"3 - Servindo o {cha_escolhido} gelado.")
else:
    cha.append(f"3 - Opção quente ou gelado não escolhida corretamente.")

if ask_5 == "l":
    cha.append("4 - Estilo inglês, adorei!")
elif ask_5 == "a":
    cha.append("4 - Bem docinho, que delícia!")
elif ask_5 == "m":
    cha.append("4 - Doce natural com mel!")
elif ask_5 == "t":
    cha.append("4 - Chá completinho? Pode deixar!")
else:
    cha.append("4 - Escolha inválida, sem adições.")

if ask_6 == "c":
    cha.append("5 - Bem mexidinho com a colher!")
elif ask_6 == "ca":
    cha.append("5 - Mexendo com um canudo!")
elif ask_6 == "p":
    cha.append("5 - Um palito para mexer, porque não?")
else:
    cha.append("5 - Escolha inválida, sem mexer.")

if ask_7 == "l":
    cha.append("6 - Adicionando um toque de limão!")
elif ask_7 == "h":
    cha.append("6 - Refrescando com hortelã!")
elif ask_7 == "g":
    cha.append("6 - Um toque de gengibre picante!")
elif ask_7 == "nada":
    cha.append("6 - Mantendo simples, sem adições especiais.")
else:
    cha.append("6 - Opção de toque especial não escolhida corretamente.")

if ask_8 == "s":
    cha.append("7 - Aproveitando uma trilha sonora relaxante enquanto prepara o chá!")
elif ask_8 == "n":
    cha.append("7 - Preparando o chá em silêncio.")
else:
    cha.append("7 - Opção musical não escolhida corretamente.")

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

# Carregar comentários existentes
comentarios = carregar_comentarios()

# Adição de comentários
speak("E ai gostou? Quer deixar um comentário?")
print("Comentar? (s/n): ")
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
if comentarios == True:
    speak("Aqui estão os comentários dos usuários:")
    print("\nComentários dos usuários:")
    for comentario in comentarios:
        print(f"- {comentario}")
else:
    speak("Muito obrigado!")

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

## Função para atualizar pontos
def atualizar_pontos(pontos_atuais, pontos_rodada=10):
    return pontos_atuais + pontos_rodada

# Função para verificar desbloqueio de chás e acompanhamentos secretos
def verificar_desbloqueio(pontos):
    global chas_secretos_desbloqueados, acompanhamentos_secretos_desbloqueados
    chas_desbloqueados_rodada = []
    acomp_desbloqueados_rodada = []
    for cha, valor in chas_secretos_valores:
        if pontos >= valor and cha not in chas_secretos_desbloqueados:
            chas_secretos_desbloqueados.append(cha)
            chas_desbloqueados_rodada.append(cha)
    for acomp, valor in acompanhamentos_secretos_valores:
        if pontos >= valor and acomp not in acompanhamentos_secretos_desbloqueados:
            acompanhamentos_secretos_desbloqueados.append(acomp)
            acomp_desbloqueados_rodada.append(acomp)
    return chas_desbloqueados_rodada, acomp_desbloqueados_rodada

# Função para calcular a pontuação com base nas combinações secretas
def calcular_pontuacao(cha, acomp):
    combinacoes_secretas = [
    ("Chá preto", "Bolachas de aveia"),
    ("Chá verde", "Pão de mel"),
    ("Chá de camomila", "Biscoitos de gengibre"),
    ("Chá de hortelã", "Muffins de mirtilo"),
    ("Chá de gengibre", "Pão de queijo"),
    ("Chá de hibisco", "Fatias de bolo de laranja"),
    ("Chá de erva-doce", "Scones com geleia"),
    ("Chá de jasmim", "Torradas com manteiga"),
    ("Chá de limão", "Biscoitos amanteigados"),
    ("Chá de canela", "Fatias de bolo (fubá, cenoura, limão)"),
    ("Chá de frutas vermelhas", "Tartes de frutas"),
    ("Chá de maçã e canela", "Fatias de pão integral com mel"),
    ("Chá de rooibos", "Croissants"),
    ("Chá de erva-mate", "Cookies de chocolate"),
    ("Chá de oolong", "Pães de frutas"),
    ("Chá de echinacea", "Sanduíches de pepino"),
    ("Chá de hibisco e rosas", "Bolinho de chuva"),
    ("Chá de capim-cidreira", "Madeleines"),
    ("Chá branco", "Brownies"),
    ("Chá de maracujá", "Pastéis de nata"),
    ("Chá de menta", "Torta de maçã"),
    ("Chá de verbena", "Fatias de pão de banana"),
    ("Chá de lavanda", "Torta de noz-pecã"),
    ("Chá de limão e mel", "Muffins de amora"),
    ("Chá chai", "Pão de nozes"),
    ("Chá matcha", "Sanduíches de salmão"),
    ("Chá de romã", "Pãezinhos doces"),
    ("Chá de cranberry", "Donuts"),
    ("Chá de dente-de-leão", "Barrinhas de cereais"),
    ("Chá de hortelã-pimenta", "Mini croissants recheados"),
    ("Chá de ginseng", "Churros"),
    ("Chá de alcaçuz", "Waffles"),
    ("Chá de anis", "Panquecas"),
    ("Chá de cúrcuma", "Brioche")
    ]
    
    pontos = 0
    if (cha, acomp) in combinacoes_secretas:
        pontos += 25
    return pontos

# Incrementar pontos por finalizar a rodada
pontos = atualizar_pontos(pontos)

# Quantidade de XP ganho por chá finalizado
xp_ganho = 20

# Atualizar XP e nível
xp, nivel = atualizar_xp_nivel(xp, xp_ganho, nivel)

# Salvar XP e nível atualizados
salvar_xp_nivel(xp, nivel)

# Exibir status do XP e nível
print(f"XP atual: {xp}")
print(f"Nível atual: {nivel}")


# Verificar se algum chá secreto ou combinação secreta foi desbloqueado
chas_desbloqueados_rodada, acomp_desbloqueados_rodada = verificar_desbloqueio(pontos)

# Calcular pontos por combinação secreta
pontos_adicionais = calcular_pontuacao(cha_escolhido, acomp_escolhido)
pontos += pontos_adicionais

# Salvar pontos atualizados
salvar_pontos(pontos)

# Salvar conquistas secretas atualizadas
salvar_conquistas_secretas(chas_secretos_desbloqueados, acompanhamentos_secretos_desbloqueados)

# Exibir conquistas da rodada atual
print("\nConquistas da rodada atual:")
for cha in chas_desbloqueados_rodada:
    print(f"- Novo chá secreto desbloqueado: {cha}")
for acomp in acomp_desbloqueados_rodada:
    print(f"- Novo acompanhamento secreto desbloqueado: {acomp}")

# Exibir status do bônus de combinação secreta
if pontos_adicionais > 0:
    print(f"\nParabéns! Você acertou uma combinação secreta e ganhou {pontos_adicionais} pontos extras!")
else:
    print("\nNenhuma combinação secreta nesta rodada. Continue tentando!")

# Exibir o status dos pontos
print(f"Status atual dos pontos: {pontos}")

def mostrar_historico():
    if historico:
        print("\nHistórico de Preparações de Chá:")
        for i, preparacao in enumerate(historico, 1):
            print(f"\nPreparação {i}:")
            print(f"Chá Escolhido: {preparacao['cha_escolhido']}")
            print(f"Acompanhamento Escolhido: {preparacao['acomp_escolhido']}")
            print(f"Modo de Preparo: {' '.join(preparacao['modo_preparo'])}")
            print(f"Curiosidade: {preparacao['curiosidade']}")
            print("-" * 30)  # Separador para cada preparo
    else:
        print("Nenhum histórico de preparações de chá disponível.")

