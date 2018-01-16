import json, unittest

from app import app


class TestIndexEndpoint(unittest.TestCase):

    # Test Setup Section
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_index(self):
        """Assert that our index URL returns the specified JSON message"""
        response = self.app.get('/')
        self.assertEqual(str(json.loads(response.get_data())['message']),
                         'Welcome to PyCon KE 2017!')

    def test_hello(self):
        """Assert that our hello route returns the correct messsage"""
        response = self.app.get('/hello/arnold')
        self.assertEqual(str(json.loads(response.get_data())['message']),
                        'Hello, arnold. Welcome to PyCon KE 2017!')


if __name__ == '__main__':
    unittest.main()
