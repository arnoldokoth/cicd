import unittest


class DummyTests(unittest.TestCase):

    def test_dummy_one(self):
        self.assertTrue(1, True)

    def test_dummy_two(self):
        self.assertEqual(10, 10)

    def test_dummy_three(self):
        self.assertFalse(0, False)


if __name__ == '__main__':
    unittest.main()
