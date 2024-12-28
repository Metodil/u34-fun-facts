import os
import random
import time
import psycopg2

a = [
    "Blue",
    "Black",
    "Yellow",
    "White",
    "Green",
    "Orange",
    "Purple",
    "Pink",
    "Brown",
    "Gray",
    "Red",
]
b = [
    "Tigers",
    "Lions",
    "Crocodiles",
    "Horses",
    "Donkeys",
    "Dogs",
    "Cats",
    "Bears",
    "Pandas",
    "Coalas",
    "Chameleons",
    "Lizards",
]
c = ["Fat", "Slim", "Fast", "Slow", "Tall", "Short", "Weak", "Strong"]
d = ["Eat", "Dream", "Like", "Adore", "Trow", "Love", "Dislike"]
e = ["Oranges", "Bananas", "Tomatoes", "Potatoes", "Onions", "Cucumbers", "Nuts"]

print("Started. Looking for new fun facts ...")

while True:
    s = (
        a[random.randrange(10)]
        + " "
        + b[random.randrange(11)]
        + " Are "
        + c[random.randrange(7)]
        + " And "
        + d[random.randrange(6)]
        + " "
        + e[random.randrange(6)]
    )

    print("New fun fact discovered: " + s)

    try:
        connection = psycopg2.connect(
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            host=os.getenv("DB_HOST"),
            port=5432,
        )

        cursor = connection.cursor()
        cursor.execute("INSERT INTO facts (fact) VALUES ('" + s + "')")
        cursor.close()
        connection.commit()
    except ImportError:
        print("ERROR: Database communication error.")

    #  t = random.randrange(60, 90)
    t = random.randrange(20, 30)
    print(f"Sleep for {t} seconds")
    time.sleep(t)
