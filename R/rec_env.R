
#' Recovery Lake Stage Envelope Score
#'
#' @param data see details
#'
#' @details
#' The input `data` is a `data.frame` with columns:
#' \itemize{
#' \item{`Date` (as a `POSIXct` or `Date` variable)}
#' \item{`Data.Value` as stage elevation data in feet (NGVD29)}
#' }

#' @importFrom zoo na.approx
#' @importFrom lubridate leap_year
#' @return Returns a `data.frame` of original data and normal stage elevation score.
#'
#' @export
#'
#' @examples
#'
#' # Example dataset (not real data)
#' dat=data.frame(Date=seq(as.Date("2016-01-01"),
#' as.Date("2016-03-02"),"1 days"),Data.Value=runif(62,12,18))
#'
#' norm_env(dat)

rec_env=function(data){
  data$month=as.numeric(format(data$Date,"%m"))
  data$CY=as.numeric(format(data$Date,"%Y"))
  data$day=as.numeric(format(data$Date,"%d"))

  rec.score=data.frame(rec.stage.score)
  data=merge(data[,c("Date","month","day","CY","Data.Value")],
             rec.score,c("month","day"),all.x=T)
  data=data[order(data$Date),]

  leap=leap_year(data$Date)
  yr=unique(data[leap==T,"CY"])
  if(length(yr)>0){
    # Fills values for leap year
  for(i in 1:length(yr)){
  leap_dates=seq(as.Date(paste(yr[i],02,28,sep="-")),as.Date(paste(yr[i],03,01,sep="-")),"1 days")
  data[data$CY==yr[i]&as.Date(data$Date)%in%leap_dates,6:16]=na.approx(data[data$CY==yr[i]&as.Date(data$Date)%in%leap_dates,6:16])
  }
  }
  #Calculate Penalty
  data$Pen_Highest=with(data,ifelse(Data.Value>=Up1_2,2+2*(Data.Value-Up1_2),NA))
  data$Pen_Up1_2=with(data,ifelse(Data.Value>=Up05_1&Data.Value<Up1_2,1+(1/(Up1_2-Up05_1))*(Data.Value-Up05_1),NA))
  data$Pen_Up05_1=with(data,ifelse(Data.Value>=Upper&Data.Value<Up05_1,0.5+(0.5/(Up05_1-Upper))*(Data.Value-Upper),NA))
  data$Pen_Env=with(data,ifelse(Data.Value>=Low&Data.Value<Upper,0,NA))
  data$Pen_Low3=with(data,ifelse(Data.Value<Low3,3+2*(Low3-Data.Value),NA))
  data$Pen_Low05_1=with(data,ifelse(Data.Value<Low&Data.Value>=Low1_15,0.5+(0.5/(Low-Low1_15))*(Low-Data.Value),NA))
  data$Pen_Low1_15=with(data,ifelse(Data.Value<Low1_15&Data.Value>=Low15_2,1+(0.5/(Low1_15-Low15_2))*(Low1_15-Data.Value),NA))
  data$Pen_Low15_2=with(data,ifelse(Data.Value<Low15_2&Data.Value>=Low2_25,1.5+Low15_2-Data.Value,NA))
  data$Pen_Low2_25=with(data,ifelse(Data.Value<Low2_25&Data.Value>=Low25_3,2+(0.5/(Low2_25-Low25_3))*(Low2_25-Data.Value),NA))
  data$Pen_Low25_3=with(data,ifelse(Data.Value<Low25_3&Data.Value>=Low3,2.5+Low25_3-Data.Value,NA))
  data$Pen_Low2_3=with(data,ifelse(Data.Value<Low2_3&Data.Value>=Low3,2+(2*(Low2_3-Data.Value)),NA))
  data$score=apply(data[, 17:26], 1,FUN=function(x) max(x,na.rm=T))


  rslt=data[,c("Date","Data.Value","score")]
  options(warn = -1)
  return(rslt)

}
