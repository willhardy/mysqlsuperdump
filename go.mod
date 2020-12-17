module mysqlsuperdump

go 1.15

replace github.com/willhardy/mysqlsuperdump/dumper => ./dumper

require (
	github.com/dlintw/goconf v0.0.0-20120228082610-dcc070983490
	github.com/go-sql-driver/mysql v1.5.0
	github.com/willhardy/mysqlsuperdump/dumper v0.0.0-00010101000000-000000000000
)
