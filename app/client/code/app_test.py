import unittest
from app import app


class TestApp(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_fun_facts(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 500)


#        key = (
#            "Error: Something happened while trying to talk "
#            "to the database. If started now wait minute or two."
#        )
#        self.assertIn(key, response.data)


if __name__ == "__main__":
    unittest.main()
