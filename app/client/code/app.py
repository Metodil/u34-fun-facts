import os
import socket
import psycopg2

from flask import Flask

app = Flask(__name__)


@app.route("/")
def index():
    with open("app.tpl", encoding="utf-8") as f:
        template = f.read()

    facts = ""

    try:
        connection = psycopg2.connect(
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS"),
            host=os.getenv("DB_HOST"),
            port=5432,
        )

        cursor = connection.cursor()
        cursor.execute(
            "SELECT CONCAT('<li>', fact, '</li>') "
            "html_fact FROM facts ORDER BY id DESC LIMIT 10"
        )
        records = cursor.fetchall()

        if cursor.rowcount == 0:
            facts = "No data found yet."

        for row in records:
            facts = facts + row[0]

        cursor.close()
    except ImportError:
        facts = (
            "Error: Something happened while trying to talk "
            "to the database. If started now wait minute or two."
        )

    result = template.replace("{FACTS}", facts)

    with open("app.dat", encoding="utf-8") as f:
        build = f.read()

    result = result.replace("{BUILD}", build)
    result = result.replace(
        "{WEB_POD_NAME}", socket.gethostname()
    )  # os.getenv("WEB_POD_NAME")

    return result
