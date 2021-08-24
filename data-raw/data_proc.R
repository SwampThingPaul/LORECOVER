library(openxlsx)

# Normal Stage Envelope
norm.stage.score=read.xlsx("C:/Julian_LaCie/SCCF/RECOVER/Lake Okeechobee/fromLOSOM.xlsx",sheet=1,startRow=1 )
# norm.stage.score$Date=date.fun(convertToDate(norm.stage.score$Date))

## CleanUp
# norm.stage.score$month=as.numeric(format(norm.stage.score$Date,"%m"))
# norm.stage.score$day=as.numeric(format(norm.stage.score$Date,"%d"))
# norm.stage.score=norm.stage.score[,c(11,12,2:10)]


# Recovery Stage Envelope
rec.stage.score=read.xlsx("C:/Julian_LaCie/SCCF/RECOVER/Lake Okeechobee/fromLOSOM.xlsx",sheet=2,startRow=1 )
# rec.stage.score$Date=date.fun(convertToDate(rec.stage.score$Date))

## CleanUp
# rec.stage.score$month=as.numeric(format(rec.stage.score$Date,"%m"))
# rec.stage.score$day=as.numeric(format(rec.stage.score$Date,"%d"))
# rec.stage.score=rec.stage.score[,c(11,12,2:10)]

usethis::use_data(norm.stage.score,internal=F,overwrite=T)
usethis::use_data(rec.stage.score,internal=F,overwrite=T)
