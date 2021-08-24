
#' Normal Lake Stage Envelope Score
#'
#' @param stg.data see details
#'
#' @details
#' The input `stg.data` is a `data.frame` with columns:
#' \itemize{
#' \item{`Date` (as a `POSIXct` or `Date` variable)}
#' \item{`Data.Value` as stage elevation data in feet (NGVD29)}
#' }
#'
#' @return Returns a `data.frame` of original data and normal stage elevation score.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Example dataset (not real data)
#' dates=seq(as.Date("2016-01-01"),as.Date("2016-02-02"),"1 days")
#' dat=data.frame(Date=dates,Data.Value=runif(33,12,18))
#'
#' score=norm_env(dat)
#' # END
#' }

norm_env=function(stg.data){
  stg.data$month=as.numeric(format(stg.data$Date,"%m"))
  stg.data$CY=as.numeric(format(stg.data$Date,"%Y"))
  stg.data$day=as.numeric(format(stg.data$Date,"%d"))

  norm.score=data.frame(norm.stage.score)
  stg.data=merge(stg.data[,c("Date","month","day","CY","Data.Value")],
             norm.score,c("month","day"),all.x=T)
  stg.data=stg.data[order(stg.data$Date),]

  # leap=leap_year(stg.data$Date)
  # yr=unique(stg.data[leap==T,"CY"])
  # vars=c("LP3", "LP2.5", "LP2", "LP1.5", "LP1", "LP0.5","UP0.5", "UP1", "UP2")
  # if(length(yr)>0){
  # # Fills values for leap year
  # for(i in 1:length(yr)){
  # # leap_dates=seq(as.Date(paste(yr[i],02,28,sep="-")),as.Date(paste(yr[i],03,01,sep="-")),"1 days")
  # # stg.data[stg.data$CY==yr[i]&as.Date(stg.data$Date)%in%leap_dates,vars]=na.approx(stg.data[stg.data$CY==yr[i]&as.Date(stg.data$Date)%in%leap_dates,vars])
  #
  # leap_dates=as.Date(paste(yr[i],02,29,sep="-"))
  # stg.data[stg.data$CY==yr[i]&as.Date(stg.data$Date)%in%leap_dates,vars]=norm.score[norm.score$month==2&norm.score$day==28,vars]
  #
  # }
  # }
  ##
  zs=data.frame(zone=c("LP3", "LP2.5", "LP2", "LP1.5", "LP1", "LP0.5","UP0.5", "UP1", "UP2"),
                score=c(3,2.5,2,1.5,1.0,0.5,0.5,1.0,2.0))
  zs.f=zs$zone
  zs.s=zs$score

  ##
  stg.data$zone=with(stg.data,ifelse(is.na(Data.Value)==T,NA,
                                     ifelse(Data.Value<LP3,0,
                                            ifelse(Data.Value<LP2.5,1,
                                                   ifelse(Data.Value<LP2,2,
                                                          ifelse(Data.Value<LP1.5,3,
                                                                 ifelse(Data.Value<LP1,4,
                                                                        ifelse(Data.Value<LP0.5,5,
                                                                               ifelse(Data.Value<UP0.5,6,
                                                                                      ifelse(Data.Value<UP1,7,
                                                                                             ifelse(Data.Value<UP2,8,9)))))))))))
  stg.data$score1=with(stg.data,ifelse(zone==1,LP3,
                                       ifelse(zone==2,LP2.5,
                                              ifelse(zone==3,LP2,
                                                     ifelse(zone==4,LP1.5,
                                                            ifelse(zone==5,LP1,
                                                                   ifelse(zone==6,LP0.5,
                                                                          ifelse(zone==7,UP0.5,
                                                                                 ifelse(zone==8,UP1,NA)))))))))

  stg.data$score2=with(stg.data,ifelse(zone==1,LP2.5,
                                       ifelse(zone==2,LP2,
                                              ifelse(zone==3,LP1.5,
                                                     ifelse(zone==4,LP1,
                                                            ifelse(zone==5,LP0.5,
                                                                   ifelse(zone==6,UP0.5,
                                                                          ifelse(zone==7,UP1,
                                                                                 ifelse(zone==8,UP2,NA)))))))))
  stg.data$penalty=with(stg.data,
                        ifelse(zone==0,zs.s[1]+2*(LP3-Data.Value),
                               ifelse(zone==9,zs.s[9]+2*(Data.Value-UP2),
                                      ifelse(zone==6,0,zs.s[zone]+(zs.s[zone+1]-zs.s[zone])*(Data.Value-score1)/(score2-score1))))*sign(Data.Value-LP0.5))

  rslt=stg.data[,c("Date","Data.Value","zone","LP0.5","score1","score2","penalty")]
  options(warn = -1)
  return(rslt)
}
