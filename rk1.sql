Добавляем развязочеую таблицу DriversCars с полями driver и car
А к Fines поле driver

1. Найти все пары вида <ФИО водителя, год его автомобиля> 

SQL:
select Drivers.FIO, Cars.Year from
Drivers join DriversCars on Drivers.DriverId = DriversCars.driver
join Cars on DriverCars.car = Cars.CarId

РА:
(Drivers join DriverCars join Cars)[Drivers.FIO, Cars.Year]

ИК:
Range of DX is Drivers
Range of DCX id DriversCars
Range of CX is Cars

DX.FIO, CX.Year where exists DCX exists CX (DCX.driver = DX.driverId and DCX.car = CX.CarId)

2. Найти ФИО водителей, которым выписан штраф размером от 5000 до 10000 рублей 

SQL:
select Deivers.FIO from 
Drivers join Fines on Drivers.driverID = Fines.driver
where Fines.amount > 5000 and Fines.amount < 10000

РА:
(Drivers join Fines) where Fines.amount > 5000 and Fines.amount < 10000[Drivers.FIO]

ИК:
Range of DX is Drivers
Range of FX is Fines

DX.FIO where exists Fines(DX.driverID and Fines.driver and Fines.amount > 5000 and Fines.amount < 10000)

3. Найти водителей, у которых после 2019 года всего один штраф

SQL:
select FIO from 
Drivers join Fines on Drivers.DriverId = Fines.driver
group by Drivers.DriverId
having Fines.date.year > 2019 and count(Fines.FineID) = 1

РА:
((summarize Fines per Fines{Drivers.DriverId} add count(DriversId) as amount)[DriversId]) join Drivers)[Drivers.FIO]

ИК:
Range of DX is Drivers
Range of FX is Fines
Range of FY is Fines where count(FX.DriversId = FY.DriversId) = 1

DX where exists FY(DX.DrexerId = FY.DriverID)