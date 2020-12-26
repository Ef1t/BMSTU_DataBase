import psycopg2

class DataBase:
    def __init__(self):
        self.connect = psycopg2.connect(dbname='cybersport', user='postgres', 
                                        password='admin', host='localhost')
        self.cursor = self.connect.cursor()

    def get_player_with_max_rating(self):
        self.cursor.execute('''
            SELECT nickname 
            from cybersportsmen where
            rating = (select max(rating) from cybersportsmen)
        ''' )
        return self.cursor.fetchall()

    def select_more_inf(self):
        self.cursor.execute('''
            SELECT * from 
            (cybersportsmen join
            contracts on cybersportsmen.id = contracts.player_id) as cc 
            join brands on brands.brand_name = cc.brand_name
        ''' )
        return self.cursor.fetchall()

    def select_cte_window(self):
        self.cursor.execute('''
            WITH CTE 
            AS
            (SELECT name, nickname, rating FROM cybersportsmen
            where rating > (select max(rating) over(order by country) as "avg" from cybersportsmen
            limit 1))
            SELECT * FROM CTE
        ''' )
        return self.cursor.fetchall()

    def select_metadata(self):
        self.cursor.execute('''
            SELECT table_name, table_type
            FROM information_schema.tables
            WHERE table_schema = 'public'
        ''' )
        return self.cursor.fetchall()

    def scalar_func(self, data):
        self.cursor.callproc('scalar_func', [data])
        self.connect.commit()
        return self.cursor.fetchall()

    def multi_table_func(self):
        self.cursor.callproc('multi_table_func')
        self.connect.commit()
        return self.cursor.fetchall()

    def team_between_id(self, from_, to_, name):
        self.cursor.execute('call team_between_id({},{},{})'.format(1, 6, '\'Super Team\''))
    
    def get_version(self):
        self.cursor.callproc('version')
        self.connect.commit()
        return self.cursor.fetchall()

    def create_table(self, name):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS {name}
            (
                id          SERIAL  PRIMARY KEY,
                role        VARCHAR(30) NOT NULL,
                rating      INTEGER NOT NULL
            )
            '''.format(name = name))

        print('Table {name} successfully created\n'.format(name=name))

    def insert_data(self, name, role, rating):
        self.cursor.execute('''
            INSERT INTO {name} (role, rating) 
            VALUES (%s, %s)
            '''.format(name = name), [role, rating])
        print('Insert into {name} successfully\n'.format(name = name))
        