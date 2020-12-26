import random
from faker import Faker
import csv

CONTRACTS = 200
PLAYERS_COUNT = 800

brands = ['Coca-Cola', 'Aviasales', 'Megafone','Snickers', 'Red Bull', 'USM Holdings', 'StrongBow', 'Mountain Dew', 'Adidas', 'Nike']

def save_file_brands(items, path):
	with open(path, 'w', newline = '', encoding = 'utf-8') as file:
		writer = csv.writer(file, delimiter = ';')
		for item in items:
			writer.writerow([item['Brand\'s name'], item['Brand\'s ambassador'], item['Brand\'s email'], item['Brand\'s annual profit']])

def save_file_contracts(items, path):
	with open(path, 'w', newline = '', encoding = 'utf-8') as file:
		writer = csv.writer(file, delimiter = ';')
		for item in items:
			writer.writerow([item['Brand\'s name'], item['Player ID'], item['Contract value']])


faker = Faker()
brands_r = []
for i in range(len(brands)):
	brands_r.append({
			'Brand\'s name' : brands[i],
			'Brand\'s ambassador' : faker.name(),
			'Brand\'s email' : brands[i] + '@gmail.com',
			'Brand\'s annual profit' : "$" + str(random.randint(1000000, 10000000000))	
			})

contracts = []
for i in range(CONTRACTS):
	contracts.append({
			'Brand\'s name' : brands[random.randint(0, len(brands) - 1)],
			'Player ID' : str(random.randint(1, PLAYERS_COUNT)),
			'Contract value' : "$" + str(random.randint(10000, 100000))	
			})

save_file_brands(brands_r, 'brands.csv')
save_file_contracts(contracts, 'contracts.csv')