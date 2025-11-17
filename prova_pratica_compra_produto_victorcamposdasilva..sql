-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

-- parte 1/2

CREATE TABLE Compra_Produto (
Id_Compra Integer,
Id_Produto Integer,
Quantde_Produto Numeric(5),
VL_Parcial Numeric(5,2),
PRIMARY KEY(Id_Compra,Id_Produto)
)

CREATE TABLE Produto (
Id_Produto Integer PRIMARY KEY,
Marca Varchar(20),
Descricao Varchar(300),
Valor_unitario Numeric(5,2)
)

CREATE TABLE Atendente (
Id_Atendente Integer PRIMARY KEY,
Nome Varchar(80),
Matricula Char(11),
CPF Char(11),
RG Varchar(8),
Pis Char(11),
Telefone Varchar(50),
Email Varchar(80),
Endereco Varchar(80),
CEP Char(8)
)

CREATE TABLE Compra (
Id_Compra Integer PRIMARY KEY,
Id_Cliente Integer,
Id_Atendente Integer,
Forma_Pagamento Varchar(10),
VL_Total Numeric(7,2),
DT_Compra Date,
Hora_Pagamento timestamp,
FOREIGN KEY(Id_Atendente) REFERENCES Atendente (Id_Atendente)
)

CREATE TABLE Cliente (
Id_Cliente Integer PRIMARY KEY,
Nome Varchar(80),
CPF Char(11),
DT_Nasc Date,
Email Varchar(80),
Sexo Char(1),
Telefone Varchar(50),
CEP Char(8),
Endereco Varchar(80)
)

ALTER TABLE Compra_Produto ADD FOREIGN KEY(Id_Compra) REFERENCES Compra (Id_Compra)
ALTER TABLE Compra_Produto ADD FOREIGN KEY(Id_Produto) REFERENCES Produto (Id_Produto)
ALTER TABLE Compra ADD FOREIGN KEY(Id_Cliente) REFERENCES Cliente (Id_Cliente)


--exe1 lista de cliente e atendente compra valor totsl

INSERT INTO cliente(id_cliente, nome, email)
    VALUES (1, 'marcelo', 'marcelo@gmail.com'),

    INSERT INTO cliente(id_cliente, nome, email)
    VALUES  (2, 'maria', 'maria@gmail.com'),  
           (3, 'pedro', 'pedro@gmail.com');



INSERT INTO atendente(
            id_atendente, nome)
    VALUES (1, 'joao'),
           (2, 'julia'),
           (3, 'thales');

UPDATE compra
SET vl_total = 3580.00
WHERE id_compra = 1;

UPDATE compra
SET vl_total = 80.00
WHERE id_compra = 2;

UPDATE compra
SET vl_total = 150.00
WHERE id_compra = 3;

SELECT id_compra, id_cliente,id_atendente, vl_total
FROM compra;

--parte 3 

--exe2L iste os produtos vendidos, quantidade e valor parcial por compra         

INSERT INTO produto(
            id_produto, marca, valor_unitario)
    VALUES (1, 'notebbok', '3.500'),
           (2, 'mouse', '80.00'),
           (3, 'teclado', '150.00');

           SELECT 
    cp.id_compra,
    p.marca AS nome_produto,
    cp.quantde_produto AS quantidade,
    cp.vl_parcial AS valor_parcial
FROM compra_produto cp
JOIN produto p ON cp.id_produto = p.id_produto
ORDER BY cp.id_compra;




--exe3 compras realizadas apos 2025-10-01 
           INSERT INTO compra(
            id_compra, id_cliente, id_atendente,  vl_total, 
            dt_compra)
    VALUES (1, 1, 1, '3.500','2025-10-01'),
           (2, 2, 2, '80.00','2025-10-15'),
           (3, 3, 3, '150.00','2025-10-20');

           SELECT *
FROM compra
WHERE dt_compra > '2025-10-01';


           
--exe 2 quantida e valor parcial dos produtos 


           INSERT INTO compra_produto(
            id_compra, id_produto, quantde_produto, vl_parcial)
    VALUES (1, 1, 1, '3.500'),
           (2, 2, 3, '80.00'),
           (3, 3, 2, '150.00');


SELECT *
FROM compra_produto;

-- exe4 liasta dos clientes que realizaram mais de uma compra 


INSERT INTO compra(
    id_compra, id_cliente, id_atendente, vl_total, dt_compra)
VALUES (4, 1, 2, '500.00','2025-10-30');





SELECT 
    c.nome AS cliente,
    COUNT(co.id_compra) AS quantidade_compras
FROM compra co
JOIN cliente c ON co.id_cliente = c.id_cliente
GROUP BY c.nome
HAVING COUNT(co.id_compra)>1;

--exe1 parte 4 criar uma tabela estoque 
create table estoque (
id_estoque serial primary key,
id_produto integer references produto (id_produto),
quantidade integer not null, 
localizacao varchar (100) 
);


--exe 2 colocar todos os estoques para 100

alter table produto add column estoque integer;
update produto 
set quantidade = 100;

select id_produto, descricao, estoque 
from produto;

alter table produto add column estoque integer;
select * from estoque
;

create table estoque (
id_estoque serial primary key, 
id_produto integer references produto(id_produto),
quantidade integer
);

insert into estoque (id_produto, quantidade)
select Id_produto, 100
from produto 
on conflict (id_produto) do update 
set quantidade=100;

update estoque
set quantidade = 100;

insert into estoque (id_produto, quantidade)   
select id_produto, 0
from produto;

select * from estoque

--exe3 psrte 4 atualize o email de maria 

select * from cliente;
select column_name
from information_schema.columns
where table_name = 'cliente';

update cliente 
set 
    nome  = 'maria silva'
where id_cliente =2;

select id_cliente,nome, email from cliente;

--parte 5 exe 1 calcule o total de vendas 

select sum (vl_totsl) as total_geral_vendas
from compra;

select column_name
from information_schema.columns 
where table_name = 'comprs';

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'compra';
SELECT current_database();

create database db_compra_produto 
create table produto as 
select * from produto provs;

SELECT SUM(vl_total) AS total_geral_vendas
FROM compra produto;



--exe 2 parte 5

--mostre o nome do produto mais caro e seu valor 



SELECT 
    p.marca AS nome_produto,
    SUM(cp.vl_parcial) AS valor_total_vendido
FROM compra_produto cp
JOIN produto p ON cp.id_produto = p.id_produto
GROUP BY p.marca
ORDER BY valor_total_vendido DESC
LIMIT 1;

--exe 3  5 parte

--exiba todos os atendentes e o numero de vendas resgistradas 

SELECT 
    a.nome AS atendente,
    COUNT(c.id_compra) AS numero_vendas
FROM atendente a
LEFT JOIN compra c ON a.id_atendente = c.id_atendente
GROUP BY a.nome
ORDER BY numero_vendas DESC;