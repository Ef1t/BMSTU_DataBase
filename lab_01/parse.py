import requests
from bs4 import BeautifulSoup as BS
import random 
import csv
from faker import Faker
import string

PAGE_COUNT = 40
identety = 1

URL = 'https://ggscore.com/en/csgo/player'
HEADERS = {'user-agent' : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Mobile Safari/537.36 ',
'accept' : '*/*'}

def is_latin(str):
	words = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM "
	for word in str:
		if word not in words:
			return 0
	return 1

def is_team(str):
	words = "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM "
	for word in str:
		if word not in words:
			return 0
	return 1

def get_html(url, params = None):
	r = requests.get(url, headers = HEADERS, params = params)
	return r

def get_name(url):
	faker = Faker()
	html = get_html(url)
	soup = BS(html.text, 'html.parser')
	name = soup.find('td').find_next('td').get_text()
	if name == '–' or not is_latin(name):
		name = faker.name()
	return name

def save_file_teams(items, path):
	with open(path, 'w', newline = '', encoding = 'utf-8') as file:
		writer = csv.writer(file, delimiter = ';')
		#writer.writerow(['Team', 'Founded', 'Prize amount'])
		for item in items:
			writer.writerow([item['Team'], item['Founded'], item['Prize amount']])

def get_content(html, clubs):
	global identety
	faker = Faker()
	soup = BS(html, 'html.parser')
	items = soup.find('table', class_ = 'mtable').find_all('tr', class_ = 't-item')

	cybersportsmen = []
	
	for item in items:
		club_name = item.find('u')
		if club_name:
			club_name = club_name.get_text()
		else:
			club_name = 'Free Player'

		if not is_team(club_name):
			club_name = 'Super Team'

		url = item.find('a').get('href')
		url = 'https://ggscore.com/' + url
		clubs.append(club_name);
		cybersportsmen.append({
			'id' : str(identety),
			'Name' : get_name(url),
			'Nickname' : item.find('a').get_text(),
			'Country' : item.find('img').get('title'),
			'Team' : club_name,
			'Prize amount' : item.find('td', class_ = 'scm').get_text(),
			'Rating' : item.find('td', class_ = 'scm').find_next('td').find_next('td').get_text()	
			})

		identety += 1		
	return cybersportsmen

def save_file_cs(items, path):
	with open(path, 'w', newline = '', encoding = 'utf-8') as file:
		writer = csv.writer(file, delimiter = ';')
		for item in items:
			writer.writerow([item['id'], item['Name'], item['Nickname'], item['Country'], item['Team'], item['Prize amount'], item['Rating']])
			#writer.writerow([item['Name'], item['Nickname'], item['Country'], item['Team'], item['Prize amount'], item['Rating']])


def parse():
	html = get_html(URL)
	cybersportsmen = []
	clubs = []
	for player in range(1, PAGE_COUNT + 1):
		print("Parsing page " + str(player) + " from " + str(PAGE_COUNT) + "...")
		html = get_html(URL + "?s=" + str(player))
		cybersportsmen.extend(get_content(html.text, clubs))
	save_file_cs(cybersportsmen, 'cybersportsmen.csv')
	teams = list(dict.fromkeys(clubs))
	teams_r = []

	for i in range(len(teams)):
		if teams[i] == "Free Player":
			teams_r.append({
				'Team' : teams[i],
				'Founded' : 2000,
				'Prize amount' : '$0'
				})
		else:
			teams_r.append({
				'Team' : teams[i],
				'Founded' : str(random.randint(2000, 2010)),
				'Prize amount' : '$' + str(random.randint(1000000, 10000000))
				})
	save_file_teams(teams_r, 'teams.csv')
	
parse()