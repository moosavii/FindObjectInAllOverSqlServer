declare @dbname varchar(max)
		, @query varchar(max)
		, @searchItem varchar(max)

declare cursor1 scroll cursor
for
	select '[' + [name] + ']'
	from sys.databases
	where owner_sid <> 0x01

open cursor1
	fetch next from cursor1 into @dbname
	while @@FETCH_STATUS = 0
		BEGIN
			PRINT @dbname
			set @query = ''
			set @query = ' select ''' + @dbname + ''' , objects.name , objects.type_desc , create_date , modify_date '
					+ ' from sys.objects '
					+ ' left join '
					+ @dbname + '.sys.sql_modules '
					+ ' on sql_modules.object_id = objects.object_id '
					+ ' where definition like ''%' + @searchItem + '%'''

			print @query
			begin try
				exec(@query)
			end try
			begin catch
				select ERROR_MESSAGE()
			end catch
			fetch next from cursor1 into @dbname
		end
close cursor1
deallocate cursor1

