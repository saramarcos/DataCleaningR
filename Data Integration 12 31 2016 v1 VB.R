#cleans Working Environment
rm(list=ls())

#resets memory usage (similar to reset RStudio)
makeActiveBinding("refresh", function() { system(paste0(R.home(),"/bin/i386/R")); q("no") }, .GlobalEnv)
paste0(R.home(),"/bin/i386/R --no-save") #--save will save workspace

# options(stringsAsFactors = FALSE)

#cleans Working Environment
rm(list=ls())

##############################################
#Define paths
##############################################

#Set working directory To Project Directory (Manual: Session/Set Working Directory/To Project Directory)
setwd("C:/Personal/71032003/SWP R Syntax/swp-r-syntax")
# setwd("Z:/Projects-SWP/SWP - R/")

source(paste(getwd(), "PepMacro/PepMacro_MasterReadIn.R", sep = '/'))

####################

#China
china = read_datatable(paste(rawdata_path, "China SWP Original Data as of Dec 31 2015 v1.xlsx", sep = '/') )
setnames(china, gsub("\\.", "", names(china)) )
setnames(china, gsub("/", "", names(china)) )
china[,Year := 2015]
china = clean_dates_dt(china, 'xlsx')

# china2 <- as.data.table(read_excel(paste(rawdata_path, "China SWP Original Data as of Dec 31 2015 v1.xlsx", 
#                                          sep = '/'),sheet = 1, col_names = TRUE))
# setnames(china2, gsub(" ", "", names(china2)) )
# china2 = clean_dates_dt(china2, 'xlsx2')
# 
# all.equal(china2,china)

master <- add_new_dataset(new_dt = china, Country_num = 1, diffvars_meth = 2, old_dt = NULL)
rm(china)

#India
india <- read_datatable(paste(rawdata_path, "India SWP Original Data as of Dec 31 2015 v1.xlsx", sep = '/') )
setnames(india, gsub("\\.", "", names(india)) )
setnames(india, gsub("/", "", names(india)) )
india[,Year := 2015]
india <- clean_dates_dt(india, 'xlsx')

master <- add_new_dataset(new_dt = india, Country_num = 2, diffvars_meth = 2, old_dt = master)
rm(india)

#Mexico
mexico <- read_datatable(paste(rawdata_path, "Mexico_2015_data.sav", sep = '/') )
mexico <- mexico[Year == 2015]
mexico[annualrate_miss == 1, AnnualRate:= NA]
mexico[, Emplid:=sprintf("%08d", GPID)]
mexico[, JHPositionJobCode:=as.character(PositionCode)]
mexico[, JHLocation:=as.character(LocationCode)]
mexico[, JHCostCenter:=as.character(CostCenter)]
mexico[, CurrentManagerEmplid:=as.character(supid)]
mexico[, JHBandGradeLevelReportable:=as.character(level)]

mexico <- rename(mexico, c("EmplStatus"="JHSAPStatus", "EmployeeName"="Name", "EmplType"="EmplType_MX", 
                 "MostRecentHireDate"="MostRecentHireDate_MX","BandGradeEntryDate"="JHBandGradeEntryDate",
                 "PositionJobCodeEntryDate"="JHPositionJobCodeEntryDate","BandGradeLevel"="JHBandGradeLevel",
                 "BandGradeLevelHarmonized"="JHBandGradeLevelHarmonized","City"="City_MX",
                 "OrgLvl2ShortDescription"="JHOrgLvl2ShortDescription","OrgLvl3ShortDescription"="JHOrgLvl3ShortDescription",
                 "OrgLvl4ShortDescription"="JHOrgLvlShort4Description","OrgLvl5ShortDescription"="JHOrgLvl5ShortDescription",
                 "OrgLvl6ShortDescription"="JHOrgLvl6ShortDescription","OrgLvl8ShortDescriptionSubfuncti"="JHOrgLvl8ShortDescriptionSubfunction",
                 "OrgLvl9Description"="JHOrgLvl9Description","CostCenterDesc"="JHCostCenterDescription",
                 "AnnualRate"="JHAnnualRate","CurrencyCode"="JHCurrencyCode","StdHours"="JHStandardHours",
                 "AnnualBonus"="AnnualBonus_MX","AnnualBonusTargetPercent"="JHAnnualBonusTargetPercent",
                 "PeopleRating"="JHPeopleRating","BusinessRating"="JHBusinessRating","CompIndex"="JHCompensationIndex",
                 "TalentCall"="TalentCall_MX","FullPartTime"="JHFullPartTime","termdt"="TerminationDate",
                 "turnover_type"="JHActionReasonDescription","function_eng"="JHOrgLvl7ShortDescriptionFunction",
                 "annualbonus1"="annualbonus1_MX","bonus_pct_target"="bonus_pct_target_MX",
                 "citystate"="JHLocationDescription","edu_level"="EDU_LVL","PositionJobCodeTitle_ENGLISH"="JHPositionJobCodeTitle",
                 "Critical_Type"="Critical_Type_MX","critical_job3"="CriticalRole_MX","TerminationReason"="TerminationReason_MX"))

# vars <- c('Year','JHSAPStatus','Name','BirthDate','Gender','OriginalHireDate','JHBandGradeEntryDate',
#           'JHPositionJobCodeEntryDate','JHBandGradeLevel','JHBandGradeLevelHarmonized',
#           'JHOrgLvl2ShortDescription','JHOrgLvl3ShortDescription','JHOrgLvlShort4Description',
#           'JHOrgLvl5ShortDescription','JHOrgLvl6ShortDescription','JHOrgLvl8ShortDescriptionSubfunction',
#           'JHOrgLvl9Description','JHCostCenterDescription','JHAnnualRate','JHCurrencyCode',
#           'JHStandardHours','JHAnnualBonusTargetPercent'
#           ,'DirectLabor','JHPeopleRating'
#           ,'JHBusinessRating','JHCompensationIndex','JHFullPartTime'
#           ,'TerminationDate','JHActionReasonDescription'
#           ,'JHOrgLvl7ShortDescriptionFunction'
#           ,'work_pct','JHLocationDescription'
#           ,'EDU_LVL','JHPositionJobCodeTitle','Emplid','JHPositionJobCode'
#           ,'JHLocation','JHCostCenter'
#           ,'CurrentManagerEmplid'
#           ,'JHBandGradeLevelReportable')

mexico <- mexico[, .(EmplType_MX,MostRecentHireDate_MX,TerminationReason_MX,City_MX,AnnualBonus_MX,
                     TalentCall_MX,annualbonus1_MX,bonus_pct_target_MX,Critical_Type_MX,
                     CriticalRole_MX,
                     Year,JHSAPStatus,Name,BirthDate,Gender,OriginalHireDate,JHBandGradeEntryDate,
                     JHPositionJobCodeEntryDate,JHBandGradeLevel,JHBandGradeLevelHarmonized,
                     JHOrgLvl2ShortDescription,JHOrgLvl3ShortDescription,JHOrgLvlShort4Description,
                     JHOrgLvl5ShortDescription,JHOrgLvl6ShortDescription,JHOrgLvl8ShortDescriptionSubfunction,
                     JHOrgLvl9Description,JHCostCenterDescription,JHAnnualRate,JHCurrencyCode,
                     JHStandardHours,JHAnnualBonusTargetPercent,DirectLabor,JHPeopleRating,
                     JHBusinessRating,JHCompensationIndex,JHFullPartTime,TerminationDate,
                     JHActionReasonDescription,JHOrgLvl7ShortDescriptionFunction,work_pct,
                     JHLocationDescription,EDU_LVL,JHPositionJobCodeTitle,Emplid,JHPositionJobCode,
                     JHLocation,JHCostCenter,CurrentManagerEmplid,JHBandGradeLevelReportable)]
# for (i in names(russia)) { print (paste(i, class(russia[, get(i)])))}

# mexico <- clean_dates_many(mexico, c('MostRecentHireDate_MX', 'BirthDate', 'OriginalHireDate', 
#                                    'JHBandGradeEntryDate','JHPositionJobCodeEntryDate', 
#                                    'TerminationDate'), 'SPSS')
# 
# mexico <- trim.spaces_many(mexico, c("EmplType_MX","TerminationReason_MX","City_MX","TalentCall_MX",
#                                    "Critical_Type_MX","JHSAPStatus","Name","Gender","JHBandGradeLevel",
#                                    "JHBandGradeLevelHarmonized","JHOrgLvl2ShortDescription",
#                                    "JHOrgLvl3ShortDescription","JHOrgLvlShort4Description",
#                                    "JHOrgLvl5ShortDescription","JHOrgLvl6ShortDescription",
#                                    "JHOrgLvl8ShortDescriptionSubfunction","JHOrgLvl9Description",
#                                    "JHCostCenterDescription","JHCurrencyCode","JHFullPartTime",
#                                    "JHActionReasonDescription","JHOrgLvl7ShortDescriptionFunction"))
mexico <- clean_dates_dt(mexico, 'SPSS')
mexico <- trim.spaces_dt(mexico)

master <- add_new_dataset(new_dt = mexico, Country_num = 3, diffvars_meth = 2, old_dt = master)
rm(mexico)

#Brazil
brazil <- read_datatable(paste(rawdata_path, "Brazil SWP Original Data as of Dec 31 2015 v1.xlsx", sep = '/') )
setnames(brazil, gsub("\\.", "", names(brazil)) )
setnames(brazil, gsub("/", "", names(brazil)) )
brazil[,Year := 2015]
brazil <- clean_dates_dt(brazil, 'xlsx')

master <- add_new_dataset(new_dt = brazil, Country_num = 4, diffvars_meth = 2, old_dt = master)
rm(brazil)


#Turkey
turkey <- read_datatable(paste(rawdata_path, "Turkey SWP Original Data as of Dec 31 2015 v1.xlsx", sep = '/') )
setnames(turkey, gsub("\\.", "", names(turkey)) )
setnames(turkey, gsub("/", "", names(turkey)) )
turkey[,Year := 2015]
turkey <- clean_dates_dt(turkey, 'xlsx')

master <- add_new_dataset(new_dt = turkey, Country_num = 5, diffvars_meth = 2, old_dt = master)
rm(turkey)


#Russia
russia <- read_datatable(paste(rawdata_path, "Russia SWP Original Data as of Dec 31 2015 v2.sav", sep = '/') )
russia <- trim.spaces_dt(russia)
russia <- clean_dates_dt(russia, 'SPSS')
russia <- clean_dates_many(russia, 'DtMRHire_Raw', 'SPSS') 
russia[, c("JHPOS0", "JHORG1", "JHORG0", "CURRE0") := NULL]

master <- add_new_dataset(new_dt = russia, Country_num = 6, diffvars_meth = 2, old_dt = master)
rm(russia)


#NAB SC
nab <- read_datatable(paste(rawdata_path, "NAB SWP Original Data as of Dec 31 2012-2015 v1.xlsx", sep = '/') )
setnames(nab, gsub("\\.", "", names(nab)) )
setnames(nab, gsub("/", "", names(nab)) )
nab <- clean_dates_dt(nab, 'xlsx')
nab[, Dataasof:= xlsx2date(Dataasof)]
nab[, Year:=year(Dataasof)]
nab[, c("Dataasof", "JHEmployeeStatus", "JHEmployeeStatusDescription") := NULL]

master <- add_new_dataset(new_dt = nab, Country_num = 7, diffvars_meth = 2, old_dt = master)
rm(nab)

#UK
uk <- read_datatable(paste(rawdata_path, "Workforce Outcome UK_2011-2015 v4.xlsx", sep = '/') )
setnames(uk, gsub("\\.", "", names(uk)) )
setnames(uk, gsub("/", "", names(uk)) )
uk <- clean_dates_dt(uk, 'xlsx')
uk[, Year:=year(JHAsoffEffectiveDate)]
uk[, c("JHAsoffEffectiveDate", "JHEmployeeStatus", "JHEmployeeStatusDescription") := NULL]

master <- add_new_dataset(new_dt = uk, Country_num = 8, diffvars_meth = 2, old_dt = master)
rm(uk)


#ESSA SC
essasc <- read_datatable(paste(rawdata_path, "SWP ESSA SC.Ops FL-B5 2011-2015 04182016 v19.xlsx", sep = '/') )
setnames(essasc, gsub("\\.", "", names(essasc)) )
setnames(essasc, gsub("/", "", names(essasc)) )
essasc <- clean_dates_dt(essasc, 'xlsx')
essasc[, c("JHEmployeeStatusDescription") := NULL]
essasc <- rename(essasc, c("DataAsof"="Year"))

# master[, .N, by = year(BirthDate)]
master <- add_new_dataset(new_dt = essasc, Country_num = 9, diffvars_meth = 2, old_dt = master)
rm(essasc)


#Ukraine & CIS
ukrcis <- read_datatable(paste(rawdata_path, "SWP Ukraine & CIS 2011-2015 04182016 v6.xlsx", sep = '/') )
setnames(ukrcis, gsub("\\.", "", names(ukrcis)) )
setnames(ukrcis, gsub("/", "", names(ukrcis)) )
ukrcis <- clean_dates_dt(ukrcis, 'xlsx')
ukrcis[, JHPeopleRating := as.numeric(JHPeopleRating)]
ukrcis[, JHBusinessRating := as.numeric(JHBusinessRating)]
ukrcis[, JHCompensationIndex := as.numeric(JHCompensationIndex)]
ukrcis[, c("JHStandardHours", "JHAnnualBonusTargetPercent", "JHPremiumBonusTargetPercent") := NULL]
ukrcis <- rename(ukrcis, c("DataAsof"="Year", "TalentCall"="TalentCall_UA", "Highestdegree"="EDU_LVL"))

master <- add_new_dataset(new_dt = ukrcis, Country_num = 10, diffvars_meth = 2, old_dt = master)
rm(ukrcis)

#some cleaning---
for (var in names(master)){
  if (class(master[, get(var)]) == class("aaaa") ){
    # print(var)
    master[is_missing(eval(as.name(var))), eval(as.name(var)) := NA]
  }
}
for (var in names(master)){
  if (grepl("date",tolower(var))) {
    # print(var)
    master[, eval(as.name(var)) := as.Date(eval(as.name(var)))]
  }
}
master[, DtMRHire_Raw := as.Date(DtMRHire_Raw)] 

###
country_labels = c("China", "India", "Mexico", "Brazil", "Turkey", "Russia", 
           "NAB SC", "UK", "ESSA SC", "Ukraine & CIS")
country_levels = c(1,2,3,4,5,6,7,8,9,10)
master[, Country_label := factor(master$Country, levels = country_levels, labels = country_labels)]

##############################

#Start cleaning
master <- master[!is_missing(Emplid), ]

#Create country dummies
master[, Country_China:= as.numeric((Country == 1))]
master[, Country_India:= as.numeric((Country == 2))]
master[, Country_Mexico:= as.numeric((Country == 3))]
master[, Country_Brazil:= as.numeric((Country == 4))]
master[, Country_Turkey:= as.numeric((Country == 5))]
master[, Country_Russia:= as.numeric((Country == 6))]
master[, Country_NAB_SC:= as.numeric((Country == 7))]
master[, Country_UK:= as.numeric((Country == 8))]
master[, Country_ESSA_SC:= as.numeric((Country == 9))]
master[, Country_Ukraine_CIS:= as.numeric((Country == 10))]


#Block all non regular employees in Russia dataset
master[Country != 6, Russia_Dups:= 1]
master[Country == 6, Russia_Dups:= Emptype]

master[Country != 6, Emptype:= 1]
master[Country == 3 & EmplType_MX != 'Regular', Emptype:= 3]


#Data As Of Date and Begin and End of year
master[,DataAsOfDate:= as.Date(paste("31/12/", Year), format = "%d/%m/%Y")]
master[,BeginofYear:= as.Date(paste("01/01/", Year), format = "%d/%m/%Y")]
master[,EndofYear:= as.Date(paste("31/12/", Year), format = "%d/%m/%Y")]


#Year dummies
master <- create_dummies2(master, 'Year', Threshold = 0) 
master <- rename(master, c("Name"="EMPLOYEENAME", "CurrentManagerEmplid" = "ManagerGPID",
                           "CurrentManagerName" = "ManagerName"))

for (i in 1:15){
  manager_ln <- paste("ManagerLvl", i, "LastName", sep = "")
  manager_fn <- paste("ManagerLvl", i, "FirstName", sep = "")
  manager_n <- paste("ManagerLvl", i, "Name", sep = "")
  
  master[!is_missing(trim.spaces(eval(as.name(manager_ln)))) | 
           !is_missing(trim.spaces(eval(as.name(manager_fn)))), 
         eval(as.name(manager_n)):= paste(eval(as.name(manager_ln)),eval(as.name(manager_fn)), sep = (", "))]
  master[is_missing(eval(as.name(manager_n))), eval(as.name(manager_n)):= '']
  master[,c(manager_ln, manager_fn) := NULL ] 
}

# master[!is_missing(trim.spaces(ManagerLvl1LastName)) | !is_missing(trim.spaces(ManagerLvl1FirstName)), 
#        ManagerLvl1Name:= paste(ManagerLvl1LastName,ManagerLvl1FirstName, sep = (", "))]
# master[is_missing(ManagerLvl1Name), ManagerLvl1Name:= '']


# Turnovers
master[, TermYear:= 0]
master[!is_missing(TerminationDate) & TerminationDate >= BeginofYear & TerminationDate <=EndofYear, TermYear:= 1]

TurnoverType <- read_datatable(paste(rawdata_path, "Turnover Type NAB & Countries 2015.xlsx", sep = '/') )

master <- merge(x = master, y = TurnoverType, by = "JHActionReasonDescription", all.x = TRUE)
rm(TurnoverType)

master[, Turnover:= 0]
master[TermYear == 1 & TurnoverType %in% c('Voluntary', 'Involuntary', 'Other'), Turnover:=1]

master[Turnover == 0, TurnoverType := '']
master[Turnover == 1, TermDate := TerminationDate]

master[, Turnover_tmp:=Turnover]
master[!is_missing(RehireDate) & RehireDate >= TermDate, Turnover_tmp:=0]

# master[, .N, by = TurnoverType]
# master[, .N, by = Turnover_tmp]
# master[, .N, by = Turnover.]

master[Turnover_tmp == 1, Status := 'Terminated']
master[Turnover_tmp == 0 & JHSAPStatus %in% c('Active', 'Withdrawn'), Status := 'Active']
master[Turnover_tmp == 0 & JHSAPStatus %in% c('Inactive', 'On Leave', 'Leave With Pay', 'Leave of Absence'), Status := 'On Leave']

master <- Lag_Vars(master, c('Turnover_tmp'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 1)
master <- Lag_Vars(master, c('Turnover_tmp'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 2)
master <- Lag_Vars(master, c('Turnover_tmp'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 3)
master <- Lag_Vars(master, c('Turnover_tmp'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 4)
master <- Lag_Vars(master, c('Turnover_tmp'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 5)

##to do, general
#characters .> blank => NA

#Checks
# aaa <- read_datatable(paste(rawdata_path, "Untitled3.sav", sep = '/') )
# aaa <- trim.spaces_dt(aaa)
# aaa <- clean_dates_dt(aaa, 'SPSS')
# xx <- merge(x = master, y = aaa, by = c('Emplid', 'Year', 'Russia_Dups', 'Country'), all.x = TRUE)
# xx[(Turnover_tmp_LAG1.y != Turnover_tmp_LAG1.x) | (is_missing(Turnover_tmp_LAG1.y) & !is_missing(Turnover_tmp_LAG1.x) ) | (is_missing(Turnover_tmp_LAG1.x) & !is_missing(Turnover_tmp_LAG1.y) ), .(Emplid, Year, Russia_Dups, Country, Turnover_tmp.x, Turnover_tmp.y, TerminationDate)] -> zx
# xx[ Emplid == '00006074', .(Emplid, Year, Russia_Dups, Country, Turnover_tmp.x, Turnover_tmp.y, 
#                             TerminationDate, Turnover_tmp_LAG1.x, Turnover_tmp_LAG1.y)]


master[, FlagTerm := 0]
master[(Turnover_tmp_LAG1==1 | Turnover_tmp_LAG2==1 | Turnover_tmp_LAG3==1 | Turnover_tmp_LAG4==1 |
          Turnover_tmp_LAG5==1) & RehireDate < TerminationDate, FlagTerm := 1]
master[!is_missing(TerminationDate) & !is_missing(RehireDate) & TerminationDate > RehireDate & year(TerminationDate) < Year &
         year(RehireDate) < Year, FlagTerm := 1]
master[!is_missing(TerminationDate) & is_missing(RehireDate) & year(TerminationDate) < Year, FlagTerm := 1]

master <- master[FlagTerm == 0, ]

master[,c("Turnover_tmp_LAG1", "Turnover_tmp_LAG2", "Turnover_tmp_LAG3", "Turnover_tmp_LAG4","Turnover_tmp_LAG5", "FlagTerm") := NULL ] 

master[, TERMINATIONREASON:= JHActionReasonDescription]
master[Status != 'Terminated', TERMINATIONREASON:= '']

master[, STAT_Active := as.numeric(Status == "Active")]
master[, STAT_Term := as.numeric(Status == "Terminated")]
master[, STAT_LV := as.numeric(Status == "On Leave")]

master[, Turn_Vol := as.numeric(Turnover == 1 & TurnoverType == 'Voluntary')]
master[, Turn_Invol := as.numeric(Turnover == 1 & TurnoverType == 'Involuntary')]
master[, Turn_Other := as.numeric(Turnover == 1 & TurnoverType == 'Other')]
master[, Turn_OtherBIG := as.numeric(Turnover == 1 & TurnoverType == 'Other')]
master[, Turn_Churn := 0]
master[, Turn_Unknown := 0]


#Hire & Rehire

master[!is_missing(RehireDate) & !Country %in% c(3, 6), MostRecentHireDate := RehireDate]
master[is_missing(RehireDate) & !Country %in% c(3, 6), MostRecentHireDate := OriginalHireDate]
master[Country == 3, MostRecentHireDate := MostRecentHireDate_MX]
master[Country == 6, MostRecentHireDate := DtMRHire_Raw]

master[, Hire:= as.numeric(!is_missing(OriginalHireDate) & year(OriginalHireDate) == Year)]
master[, ReHire:= as.numeric(!is_missing(OriginalHireDate) & year(MostRecentHireDate) == Year & year(OriginalHireDate) < year(MostRecentHireDate))]
# xx <- master[, .(Emplid, Year, OriginalHireDate, MostRecentHireDate, 
#                  MostRecentHireDate_MX, Hire, ReHire, RehireDate, DtMRHire_Raw)]

#Bandlevel
master[, Level := NULL]

master[is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'B06', Level := 17]

master[JHBandGradeLevelReportable == 'B05' | 
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'B05'), Level := 16]

master[JHBandGradeLevelReportable %in% c('15', 'B04', 'B4') | 
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'B04'), Level := 15]

master[JHBandGradeLevelReportable %in% c('14', 'B03', 'B3') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized %in% c('B03', 'E6')), Level := 14]

master[JHBandGradeLevelReportable %in% c('13', 'B02', 'B2') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'B02'), Level := 13]

master[JHBandGradeLevelReportable %in% c('12', 'B01', 'B1') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'B01'), Level := 12]

master[JHBandGradeLevelReportable %in% c('11', 'L11') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L11'), Level := 11]

master[JHBandGradeLevelReportable %in% c('10', 'L10') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L10'), Level := 10]

master[JHBandGradeLevelReportable %in% c('9', 'L09') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L09'), Level := 9]

master[JHBandGradeLevelReportable %in% c('8', 'L08') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L08'), Level := 8]

master[JHBandGradeLevelReportable %in% c('7', 'L07') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L07'), Level := 7]

master[JHBandGradeLevelReportable %in% c('6', 'L06') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L06'), Level := 6]

master[JHBandGradeLevelReportable %in% c('5', 'L05') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L05'), Level := 5]

master[JHBandGradeLevelReportable %in% c('4', 'L04') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized == 'L04'), Level := 4]

master[JHBandGradeLevelReportable %in% c('3', 'L03') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized %in% c( 'L03', 'N9', 'N8')), Level := 3]

master[JHBandGradeLevelReportable %in% c('2', 'L02') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized %in% c( 'G08', 'L02')), Level := 2]

master[JHBandGradeLevelReportable %in% c('1', 'L01') |
         (is_missing(JHBandGradeLevelReportable) & JHBandGradeLevelHarmonized %in% c( 'G06', 'L01')), Level := 1]

master[JHBandGradeLevelReportable %in% c('F', 'Hourly/Frontline', 'HOURLY/FRONTLINE', '0', 
                          'HOURLY/FRONTLINE','Hourly/FrontLine', 'G', 'H-0', 'H-1', 'H-2', 'H-3') |
         (is_missing(JHBandGradeLevelReportable) | is_missing(JHBandGradeLevelReportable))  & JHBandGradeLevelHarmonized %in% c('102', '103', '104', '6403', '6501',
                           '6503', '6505', '6507', '6603', '6605', '6607', 'COMM', 'F', 'G', 'HC1', 
                           'HC2', 'HC3', 'Hourly/Front Line','Hourly/FrontLine', 'N10', 'OTR00', 'Hourly/Frontline'), Level := 0]
master[is_missing(Level) & JHEmployeeTypeHarmonized == 'Hourly', Level:=0]

#to check the cases where we couldnt assign a level.
unique(master[is_missing(Level), .(JHBandGradeLevelHarmonized, JHBandGradeLevelReportable)])
#check that the assignations bellow are right
master[, .N,.(Level, JHBandGradeLevelReportable, JHBandGradeLevelHarmonized)]

level_labels = c("FL", "L01", "L02", "L03", "L04", "L05", "L06", "L07", "L08", "L09",
                   "L10", "L11", "B01", "B02", "B03", "B04", "B05", "B06")
level_levels = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
master[, Level_label := factor(master$Level, levels = level_levels, labels = level_labels)]


#Level groups
master[Level == 0, Level_grp := 0]
master[Level >=1 & Level <=3, Level_grp := 1]
master[Level >=4 & Level <=5, Level_grp := 2]
master[Level >=6 & Level <=7, Level_grp := 3]
master[Level >=8 & Level <=9, Level_grp := 4]
master[Level >=10 & Level <=11, Level_grp := 5]
master[Level >=12 , Level_grp := 6]

level_grp_labels = c("Fronline", "L1-L3", "L4-L5", "L6-L7", "L8-L9", "L10-L11", "B1+")
level_grp_levels = c(0,1,2,3,4,5,6)
master[, Level_grp_label := factor(master$Level_grp, levels = level_levels, labels = level_labels)]


master[Level == 0, Level_grp2 := 0]
master[Level >=1 & Level <=5, Level_grp2 := 1]
master[Level >=6 & Level <=7, Level_grp2 := 2]
master[Level >=8 & Level <=9, Level_grp2 := 3]
master[Level >=10 & Level <=11, Level_grp2 := 4]
master[Level >=12 , Level_grp2 := 5]

level_grp_labels = c("Fronline", "L1-L5", "L6-L7", "L8-L9", "L10-L11", "B1+")
level_grp_levels = c(0,1,2,3,4,5,6)
master[, Level_grp_label := factor(master$Level_grp, levels = level_levels, labels = level_labels)]

master[, Levelgrp_L1_L5:= as.numeric(Level_grp2 == 2)]

#Level dummies
master <- create_dummies2(master, 'Level', Threshold = 0) 
master <- create_dummies2(master, 'Level_grp', Threshold = 0) 

master <- rename(master, c("Level_0" = "Level_FL", "Level_1" = "Level_L1","Level_2" = "Level_L2","Level_3" = "Level_L3","Level_4" = "Level_L4",
                           "Level_5" = "Level_L5", "Level_6" = "Level_L6","Level_7" = "Level_L7","Level_8" = "Level_L8","Level_9" = "Level_L9",
                           "Level_10" = "Level_L10","Level_11" = "Level_L11","Level_12" = "Level_B1","Level_13" = "Level_B2",
                           "Level_14" = "Level_B3","Level_15" = "Level_B4","Level_16" = "Level_B5","Level_grp_0" = "Levelgrp_FL",
                           "Level_grp_1" = "Levelgrp_L1_L3","Level_grp_2" = "Levelgrp_L4_L5","Level_grp_3" = "Levelgrp_L6_L7",
                           "Level_grp_4" = "Levelgrp_L8_L9", "Level_grp_5" = "Levelgrp_L10_L11","Level_grp_6" = "Levelgrp_B1Plus"))

master[,c("Level_Other", "Level_grp_Other") := NULL ] 


##Gender
master[, Gender_F := as.numeric(Gender == 'F' & !is_missing(Gender))]
master[, Gender_M := as.numeric(Gender == 'M' & !is_missing(Gender))]
master[, Gender_Miss := as.numeric(is_missing(Gender))]

master[, Age:= as.double(difftime(DataAsOfDate, BirthDate, units = "days"))/ 365.25]
master[, TenureOrig:= as.double(difftime(DataAsOfDate, OriginalHireDate, units = "days"))/ 365.25]
master[, TenureMR:= as.double(difftime(DataAsOfDate, MostRecentHireDate, units = "days"))/ 365.25]
master[, TenureServ:= as.double(difftime(DataAsOfDate, ServiceAwardDate, units = "days"))/ 365.25]
master[, TenureBand:= as.double(difftime(DataAsOfDate, JHBandGradeEntryDate, units = "days"))/ 365.25]
master[, TenureJob:= as.double(difftime(DataAsOfDate, JHPositionJobCodeEntryDate, units = "days"))/ 365.25]

master[Age< 15 | Age > 87, Age:= NA]
master[TenureOrig < 0, TenureOrig:= NA]
master[TenureMR < 0, TenureMR:= NA]
master[TenureServ < 0, TenureServ:= NA]
master[TenureBand < 0, TenureBand:= NA]
master[TenureJob < 0, TenureJob:= NA]

master[, Age_Miss:= as.numeric(is_missing(Age))]
master[, TenureOrig_Miss:= as.numeric(is_missing(TenureOrig))]
master[, TenureMR_Miss:= as.numeric(is_missing(TenureMR))]
master[, TenureServ_Miss:= as.numeric(is_missing(TenureServ))]
master[, TenureBand_Miss:= as.numeric(is_missing(TenureBand))]
master[, TenureJob_Miss:= as.numeric(is_missing(TenureJob))]


##FUNCTION

master <- trim.spaces_many(master, 'JHOrgLvl7ShortDescriptionFunction')

master[JHOrgLvl7ShortDescriptionFunction %in% c('BIS', 'BIS LATAM', 'G&A BIS', 
           'Transformation and BIS'), Function := 1]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Commercial', 'eCommerce', 'G&A Commercialisation','Sales',
          'Sales & Marketing','Sales NKA'), Function := 2]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Communications', 'Communications/Public Affairs','G&A CORA',
          'G&A External Communications'), Function := 3]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Finance', 'Finance LATAM', 'G&A Business Transformation', 
          'G&A Finance', 'G&A Strategy', 'Strategy' ), Function := 4]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Franchise'), Function := 5]
master[JHOrgLvl7ShortDescriptionFunction %in% c('G&A GM', 'G&A Management', 'General Management', 'General Mgt', 
          'GM', 'PAM Central America and the Caribbean'), Function := 6]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Global Proc', 'Global Procurement', 'Procurement'), 
        Function := 7]
master[JHOrgLvl7ShortDescriptionFunction %in% c('G&A HR', 'HR', 'Human Resources', 'Talent and Culture'), 
        Function := 8]
master[JHOrgLvl7ShortDescriptionFunction %in% c('BU PepsiCo Confectionery and New Business', 
          'BU PepsiCo Cookies','BU PepsiCo Foods', 'BU PepsiCo Snacks', 'G&A Beverage category',
          'G&A Children Food&Modern Dairy', 'G&A Dairy Category', 'G&A Design Studio', 
          'G&A Foods category','G&A GNG', 'G&A Insights', 'G&A Juices category', 'G&A Marketing',
          'G&A Marketing Communication','G&A Medical Department','Insights','Marketing'), Function:= 9]
master[JHOrgLvl7ShortDescriptionFunction %in% c('G&A Compliance & Ethics', 'G&A Legal', 'Legal', 
          'Legal and Corporate Affairs', 'Others'), Function := 10]
master[JHOrgLvl7ShortDescriptionFunction %in% c('G&A R&D', 'G&A Regulatory', 'R&D', 
          'Research and Development'), Function := 11]
master[JHOrgLvl7ShortDescriptionFunction %in% c('Facilities', 'G&A Asset Protection', 'G&A Facility', 'G&A Quality Assurance', 
          'G&A Security', 'G&A Security Service', 'Health & Safety','Management', 'MEM', 'Operations', 
          'OPS', 'OPS-Engineering', 'OPS-H&S', 'OPS-Manufacturing', 'OPS-Purchasing', 'OPS-QA', 
          'Ops-Supply chain', 'OPS-Supply Chain','PBG Historical Org ID Level 7', 
          'SC Maintenance/Engineering', 'Security', 'Supply Chain', 'Supply Chain/Operations', 
          'Supply Chain/Ops', 'Supply ChainEurope', 'Warehouse/OT'), Function := 12]

#Replace the missing Function with Lag1
master <- Lag_Vars(master, c('Function', 'Level'), c('Emplid', 'Country', 'Russia_Dups'), 'Year', 1)

master[is_missing(Function) & !is_missing(Function_LAG1) & Level == Level_LAG1, Function:= Function_LAG1]

master[, c("Function_LAG1", "Level_LAG1") := NULL]

master[, Function_Miss := as.numeric(is_missing(Function))]
master[Function_Miss == 1, Function := 13]

function_labels = c("BIS", "Sales", "Communications", "Finance", "Franchise", "GM", "Global Procurement", 
                    "HR", "Marketing", "Legal", "R&D", "Supply Chain/Ops", "Others")
function_levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13)
master[, Function_label := factor(master$Function, levels = function_levels, labels = function_labels)]

##Function Dummies
master[, Function_BIS:= as.numeric(Function == 1)]
master[, Function_Sales:= as.numeric(Function == 2)]
master[, Function_Comm:= as.numeric(Function == 3)]
master[, Function_Finance:= as.numeric(Function == 4)]
master[, Function_Franchise:= as.numeric(Function == 5)]
master[, Function_GM:= as.numeric(Function == 6)]
master[, Function_GP:= as.numeric(Function == 7)]
master[, Function_HR:= as.numeric(Function == 8)]
master[, Function_Marketing:= as.numeric(Function == 9)]
master[, Function_Legal:= as.numeric(Function == 10)]
master[, Function_RandD:= as.numeric(Function == 11)]
master[, Function_SCOps:= as.numeric(Function == 12)]
master[, Function_Ohters:= as.numeric(Function == 13)]

master[, Function_OtherBIG:= as.numeric(Function %in% c(3, 6, 7, 13))]

##Bring City_CL in the dataset
city_cl <- read_datatable(paste(rawdata_path, "SWP City v8.xlsx", sep = '/') )

master <- merge(x = master, y = city_cl, by = c('JHLocationDescription'), all.x = TRUE)
rm(city_cl)

master[is_missing(CITY) & Country == 6, CITY:= CITY_RU]
master[is_missing(CITY) & Country == 3, CITY:= City_MX]

master[, CITY_CL:= toupper(trim.spaces(CITY))]

###############################
master[is_missing(CITY_CL), .N, by = JHLocationDescription]
"PROBLEM HERE: we get problems reading data in other encodings (ex: Brasilean) 
-- easy to solve, repeating the process we did for the cities in SPSS, for the missing cities
FOR THIS exercise of comparison, not done -- also countries found and not in SPSS are removed for comparisson.
"
cities_uft8 <- master[Emplid == 40277647][['JHLocationDescription']]
master[ JHLocationDescription == cities_uft8, CITY:= NA]
############################


master <- Lag_Vars(master, c('Function', 'Level', 'CITY_CL'), 
                   c('Emplid', 'Country', 'Russia_Dups'), 'Year', 1)
master <- Lead_Vars(master, c('Function', 'Level', 'CITY_CL'), 
                    c('Emplid', 'Country', 'Russia_Dups'), 'Year', 1)

master[is_missing(CITY_CL) & Function == Function_LAG1 & Level == Level_LAG1, CITY_CL := CITY_CL_LAG1]
master[is_missing(CITY_CL) & Function == Function_LEAD1 & Level == Level_LEAD1, CITY_CL := CITY_CL_LEAD1]


master[,CITY_CL_Miss:= as.numeric(is_missing(CITY_CL))]

master[, c("Function_LAG1", "Level_LAG1", "CITY_CL_LAG1", "Function_LEAD1", "Level_LEAD1",
           "CITY_CL_LEAD1") := NULL]

#Delete the spaces before and after - capitalize the cases.
master[, EMPLOYEENAME := toupper(trim.spaces(EMPLOYEENAME))]
master[, ManagerName:=toupper(trim.spaces(ManagerName))]
master[, ManagerLvl1Name:=toupper(trim.spaces(ManagerLvl1Name))]
master[, ManagerLvl2Name:=toupper(trim.spaces(ManagerLvl2Name))]
master[, ManagerLvl3Name:=toupper(trim.spaces(ManagerLvl3Name))]
master[, ManagerLvl4Name:=toupper(trim.spaces(ManagerLvl4Name))]
master[, ManagerLvl5Name:=toupper(trim.spaces(ManagerLvl5Name))]
master[, ManagerLvl6Name:=toupper(trim.spaces(ManagerLvl6Name))]
master[, ManagerLvl7Name:=toupper(trim.spaces(ManagerLvl7Name))]
master[, ManagerLvl8Name:=toupper(trim.spaces(ManagerLvl8Name))]
master[, ManagerLvl9Name:=toupper(trim.spaces(ManagerLvl9Name))]
master[, ManagerLvl10Name:=toupper(trim.spaces(ManagerLvl10Name))]
master[, ManagerLvl11Name:=toupper(trim.spaces(ManagerLvl11Name))]
master[, ManagerLvl12Name:=toupper(trim.spaces(ManagerLvl12Name))]
master[, ManagerLvl13Name:=toupper(trim.spaces(ManagerLvl13Name))]
master[, ManagerLvl14Name:=toupper(trim.spaces(ManagerLvl14Name))]
master[, ManagerLvl15Name:=toupper(trim.spaces(ManagerLvl15Name))]

##Bring COST CENTER in the dataset.
CostCenter <- read_datatable(paste(rawdata_path, "Cost Center # as of Dec 2015.xlsx", sep = '/') )
setnames(CostCenter, gsub("\\.", "", names(CostCenter)) )
CostCenter <- rename(CostCenter, c("JHCostCenter"="JHCostCenter_tmp", 
                                   "JHCostCenterDescription" = "JHCostCenterDescription_tmp"))

master <- merge(x = master, y = CostCenter, by = c('Emplid', 'Year'), all.x = TRUE)
rm(CostCenter)

master[is_missing(JHCostCenter), JHCostCenter := JHCostCenter_tmp]
master[is_missing(JHCostCenterDescription), JHCostCenterDescription := JHCostCenterDescription_tmp]

master[, c("JHCostCenter_tmp", "JHCostCenterDescription_tmp") := NULL]



##Merge the FX Rates Dataset with the Master.

master[Country == 6 & Year == 2015 & is_missing(JHCurrencyCode), JHCurrencyCode :=  "RUB"]

FXRates <- read_datatable(paste(rawdata_path, "FX Rates Local to USD.xlsx", sep = '/') )
FXRates[, c("CurrencyCode_NEW") := NULL]

master <- merge(x = master, y = FXRates, by = c('Year', 'JHCurrencyCode'), all.x = TRUE)
rm(FXRates)

master[JHAnnualRate > 1000 & !is_missing(FX), PayAnnRate_USD_FX := JHAnnualRate * FX]
master[, PayAnnRate_USD_FX_Miss := as.numeric(is_missing(PayAnnRate_USD_FX))]
master[PayAnnRate_USD_FX_Miss == 1, PayAnnRate_USD_FX := 0]
master[PayAnnRate_USD_FX_Miss != 1, PayAnnRate_USD_FX_LN := log(PayAnnRate_USD_FX)]
master[, PayAnnRate_USD_FX_LN_Miss := as.numeric(is_missing(PayAnnRate_USD_FX_LN))]
master[PayAnnRate_USD_FX_LN_Miss == 1, PayAnnRate_USD_FX_LN := 0]

##Manager Span of Control
master[trim.spaces(ManagerGPID) %in% c('', '.'), ManagerGPID:=NA]
master[, Manager_Span:= sum(STAT_Active), by = .(ManagerGPID, Year) ]

##Bring Performance Data in the file
PDR <- read_datatable(paste(rawdata_path, "JH_PDR Final.xlsx", sep = '/') )
setnames(PDR, gsub("\\.", "", names(PDR)) )
setnames(PDR, gsub("/", "", names(PDR)) )
PDR[, c("JHIOScore", "JHPerformanceIndicator", "JHPerformanceRating",
        "JHReviewFromDate", "JHReviewToDate") := NULL]

master <- merge(x = master, y = PDR, by = c('Emplid', 'Year'), all.x = TRUE)
rm(PDR)
### to check
#all rating variables to integer
master[, BusinessRating:= as.numeric(BusinessRating)]
master[, JHBusinessRating:= as.numeric(JHBusinessRating)]
master[, JHBusinessRating_tmp:= as.numeric(JHBusinessRating_tmp)]

master[, PeopleRating:= as.numeric(PeopleRating)]
master[, JHPeopleRating:= as.numeric(JHPeopleRating)]
master[, JHPeopleRating_tmp:= as.numeric(JHPeopleRating_tmp)]

master[, CompIndex:= as.numeric(CompIndex)]
master[, JHCompensationIndex:= as.numeric(JHCompensationIndex)]
master[, JHCompensationIndex_tmp:= as.numeric(JHCompensationIndex_tmp)]

#<= 0 is NA, before coalescing
master[BusinessRating <= 0, BusinessRating :=NA]
master[PeopleRating <= 0, PeopleRating :=NA]
master[CompIndex <= 0, CompIndex :=NA]
master[JHBusinessRating <= 0, JHBusinessRating :=NA]
master[JHPeopleRating <= 0, JHPeopleRating :=NA]
master[JHCompensationIndex <= 0, JHCompensationIndex :=NA]
master[JHBusinessRating_tmp <= 0, JHBusinessRating_tmp :=NA]
master[JHPeopleRating_tmp <= 0, JHPeopleRating_tmp :=NA]
master[JHCompensationIndex_tmp <= 0, JHCompensationIndex_tmp :=NA]

#complete missings of vars 
master[, BusinessRating := coalesce2(BusinessRating, JHBusinessRating, JHBusinessRating_tmp)]
master[, PeopleRating := coalesce2(PeopleRating, JHPeopleRating, JHPeopleRating_tmp)]
master[, CompIndex := coalesce2(CompIndex, JHCompensationIndex, JHCompensationIndex_tmp)]

master[, JHBusinessRating := coalesce2(JHBusinessRating, BusinessRating)]
master[, JHPeopleRating := coalesce2(JHPeopleRating, PeopleRating)]
master[, JHCompensationIndex := coalesce2(JHCompensationIndex, CompIndex)]

# aaa <- read_datatable(paste(rawdata_path, "Untitled3_1.sav", sep = '/') )
# aaa <- trim.spaces_dt(aaa)
# aaa <- clean_dates_dt(aaa, 'SPSS')
# xx <- merge(x = master, y = aaa, by = c('Emplid', 'Year', 'Russia_Dups', 'Country'), all.x = TRUE)
# xx[(JHBusinessRating.y != JHBusinessRating.x) | (is_missing(JHBusinessRating.y) & !is_missing(JHBusinessRating.x) ) | (is_missing(JHBusinessRating.x) & !is_missing(JHBusinessRating.y) ), 
#    .(Emplid, Year, Russia_Dups, Country, JHBusinessRating.x, JHBusinessRating.y)] -> zx
# 
# xx[ Emplid == '00006074', .(Emplid, Year, Russia_Dups, Country, Turnover_tmp.x, Turnover_tmp.y, 
#                             TerminationDate, Turnover_tmp_LAG1.x, Turnover_tmp_LAG1.y)]


master[, c("JHBusinessRating_tmp", "JHPeopleRating_tmp", "JHCompensationIndex_tmp") := NULL]

master[Country %in% c(1, 2, 4, 5, 7, 8, 9, 10), JHDATASOURCE := 'SAP']

##Getting ESSA SC
essa_sc <- master[Country %in% c(5, 6, 8, 10) & Function == 12 & Level < 8 & Emptype == 1,]

essa_sc[, Country_Turkey:=0]
essa_sc[, Country_Russia:=0]
essa_sc[, Country_UK:=0]
essa_sc[, Country_ESSA_SC:=1]
essa_sc[, Country_Ukraine_CIS:=0]
essa_sc[, Flag:=1]

master <- add_new_dataset(new_dt = essa_sc, Country_num = 9, diffvars_meth = 2, old_dt = master)
rm(essa_sc)

for (var in names(master)){
  if (grepl("date",tolower(var))) {
    # print(var)
    master[, eval(as.name(var)) := as.Date(eval(as.name(var)))]
  }
}
master[, DtMRHire_Raw := as.Date(DtMRHire_Raw)] 
master[, BeginofYear := as.Date(BeginofYear)] 
master[, EndofYear := as.Date(EndofYear)] 

master[is_missing(Flag), Flag:=0]
#sorted by ascending Flag to remove Flag=1 in case of duplicates
master<-master[order(Emplid, Year, Country, Russia_Dups, -Flag)]
z <- find_dups(master, c("Emplid", "Year", "Country", "Russia_Dups"))

master <- remove_dups(master, c("Emplid", "Year", "Country", "Russia_Dups"))
######

master[, c("Flag") := NULL]
master[, InStudy_China:= as.numeric(Country == 1)]
master[, InStudy_India:= as.numeric(Country == 2)]
master[, InStudy_Mexico:= as.numeric(Country == 3 & Emptype == 1)]
master[, InStudy_Brazil:= as.numeric(Country == 4)]
master[, InStudy_Turkey:= as.numeric(Country == 5)]
master[, InStudy_Russia:= as.numeric(Country == 6 & Emptype == 1)]
master[, InStudy_RussiaPay:= as.numeric(Country == 6 & Emptype == 1)]
master[, InStudy_NAB_SC:= as.numeric(Country == 7)]
master[, InStudy_UK:= as.numeric(Country == 8)]
master[, InStudy_ESSA_SC:= as.numeric(Country == 9)]
master[, InStudy_Ukraine_CIS:= as.numeric(Country == 10)]

master[, InStudy_All:=pmax(InStudy_China, InStudy_India, InStudy_Mexico, InStudy_Brazil, InStudy_Turkey, 
                          InStudy_Russia,InStudy_NAB_SC, InStudy_UK, InStudy_ESSA_SC,InStudy_Ukraine_CIS)]
master[, InStudy_AllPay:=pmax(InStudy_China, InStudy_India, InStudy_Mexico, InStudy_Brazil, InStudy_Turkey, 
                           InStudy_RussiaPay,InStudy_NAB_SC, InStudy_UK, InStudy_ESSA_SC,InStudy_Ukraine_CIS)]

##Save the dataset
save(master, file = paste(data_path, "master_2015.RData", sep= '/'))
load(file = paste(data_path, "master_2015.RData", sep = '/'))

names_master <- names(master)
rm(master)

### OLD MASTER

##Apparently too large to be directly converted to data.table in R 32-bits --read in data frame ->
##Removed some variables not used -> save and keep going... (!!!To do: Try in 64-bits)
old_master <- read.spss(paste(data_path, "Master SWP Dataset 11 25 2015 v14.sav", sep = '/'), 
                        to.data.frame=TRUE, use.value.labels=FALSE, trim.factor.names = TRUE)

old_master <- old_master[!names(old_master) %in% c("GENDER_Raw", "Level_LAG1", "Level_grp_LAG1", "Level_grp2_LAG1", "JHLOCATIONDESCRIPTION_LAG1", 
                                                   "JHPOSITIONJOBCODETITLE_LAG1", "MngrUniqueID_LAG1", "Function_LAG1", "CompIndex_v2_LAG1", 
                                                   "CITY_CL_LAG1", "SplitinHalf", "SmallorBig", "Promo_LEAD1", "Promo_big_LEAD1", "Promo_big2_LEAD1", 
                                                   "Demo_LEAD1", "Demo_big_LEAD1", "Demo_big2_LEAD1", "Turnover_LEAD1", "Turn_Vol_LEAD1", 
                                                   "Turn_Invol_LEAD1", "Turn_Other_LEAD1", "Turn_Churn_LEAD1", "Turn_Unknown_LEAD1", 
                                                   "Turn_OtherBIG_LEAD1", "STAT_Active_LEAD1", "STAT_Term_LEAD1", "STAT_LV_LEAD1", "ci_high_LEAD1", "ci_low_LEAD1", "EduLvl_LEAD1", "Promo_LAG1", "Promo_big_LAG1",
                                                   "Promo_big2_LAG1", "Demo_LAG1","Demo_big_LAG1", "Demo_big2_LAG1", "ci_high_LAG1", "ci_low_LAG1",
                                                   "EduLvl_LAG1", "CriticalJob_LAG1", "STAT_Active_LAG1", "STAT_Term_LAG1","CompIndex_Miss_LEAD1", 
                                                   "CompIndex_v2", "ci_high", "ci_low", "CompIndex_v2_LEAD1", "BusinessRating_tmp2", 
                                                   "PeopleRating_tmp2", "CURRENCYCODE",
                                                   "STATE", "DetailsOperations", "NewStructure", "function_Mexico", "Function_Eng_Turkey","Function_Turkey", 
                                                   "Function_Russia", "PositionJobCodeEntryDate", "Promo_big", "Promo_big2", "Demo", "Demo_big", 
                                                   "Demo_big2","LocChg", "JobChg", "ManagerChg", "FunctionChg", "WorkGroup", "WorkGroup2", 
                                                   "WorkGrpTenure_Mean", "WorkGrp_HC", "WorkGrpCI_Mean", "WorkGrpPromo_Sum", "WorkGrpTurnover_Sum", 
                                                   "WorkGrpActive_Sum", "WorkGrpTurnoverRate","WorkGrpPromoRate", "WorkGrpActive_HC", 
                                                   "WorkGrpTurnoverRate_Grp", "WorkGrpTurnoverRate_Grp_MISS", "WorkGrpTurnoverRate_Grp_Zero", 
                                                   "WorkGrpTurnoverRate_Grp_.0to.24", "WorkGrpTurnoverRate_Grp_.25to.49", "WorkGrpTurnoverRate_Grp_.50orMore",
                                                   "WorkGrpTurnoverRate_mean", "WorkGrpTurnoverRate_v2", "WorkGrpPromo", "AnnualRateChgPer", 
                                                   "Age_Grp", "Age_Grp2", "Ten_Grp", "Age_Grp_Other","Age_Grp_MISS", "Age_Grp_24orless", 
                                                   "Age_Grp_25to29", "Age_Grp_30to34", "Age_Grp_35to39","Age_Grp_40to44", "Age_Grp_45to49", 
                                                   "Age_Grp_50to54", "Age_Grp_55ormore", "Ten_Grp_Other", "Ten_Grp_MISS", "Ten_Grp_0tolt1", 
                                                   "Ten_Grp_1to2","Ten_Grp_13ormore", "Ten_Grp_3to4", "Ten_Grp_5to7", "Ten_Grp_8to12", 
                                                   "AnnualRateChgPer_v2", "AnnualRateChgPer_v2_Miss", "TenureMR_Sqr", "Promo", "CITY_CLChg", 
                                                   "City_Sao_Paulo", "City_Aparecida_De_Goiania", "City_Sao_Goncalo", "City_Tres_Lagoas",
                                                   "City_Rio_De_Janeiro", "City_AnyBrazil", "City_Shanghai", "City_Beijing", "City_Wuhan", 
                                                   "City_AnyChina", "City_New_Delhi", "City_Bombay","City_Paithan", "City_Channo", "City_Pune", 
                                                   "City_Kolkata", "City_AnyIndia", "City_Azcapotzalco", "City_San_Nicolas", "City_AnyMexico",
                                                   "City_Moscow", "City_Saint_Petersburg", "City_Lebedyan", "City_Novosibirsk", "City_AnyRussia",
                                                   "City_Istanbul", "City_Izmit", "City_Mersin", "City_Adana", "City_Izmir", "City_Tekirdag", 
                                                   "City_AnyTurkey")]

old_master <- old_master[old_master$Year != 2015,] ##Remove the Russia Dataset as of January 2015

setnames(old_master, gsub("\\.", "", names(old_master)) )
old_master <- as.data.table(old_master)

old_master[is_missing(JHPositionJobCodeEntryDate), JHPositionJobCodeEntryDate := PositionJobCodeEntryDate]

old_master[, c("TERMI0", "JHPOS1", "JHORG7", "JHORG6", "JHORG5", "JHORG4", "JHORG3", "JHORG2", "JHORG1",
               "JHORG0", "FUNCT0", "JHPOS0") := NULL]
old_master <- clean_dates_dt(old_master, 'SPSS')
old_master <- trim.spaces_dt(old_master)


old_master <- rename(old_master, c("JHORGLVL4SHORTDESCRIPTION"="JHOrgLvlShort4Description", 
                                   "JHORGLVL7" = "JHOrgLvl7ShortDescriptionFunction", 
                                   "JHORGLVL8" = "JHOrgLvl8ShortDescriptionSubfunction", 
                                   "ANNUALRATE" = "JHAnnualRate", "ANNUALBONUSTARGET" = "JHAnnualBonusTargetPercent",
                                   "FULLPARTTIME" = "JHFullPartTime", "CostCenter"="JHCostCenter", 
                                   "CostCenterDesc" = "JHCostCenterDescription", 
                                   "Expat" = "ExpatriateIndicator", "StdHrs_Raw" = "JHStandardHours", 
                                   "CurrencyCode_NEW" = "JHCurrencyCode"))

diff_case_vars <- names(old_master)[(!names(old_master) %in% names_master) & 
                                      (tolower(names(old_master)) %in% tolower(names_master))]

#For same variables with different case in Old and 2015 masters, change var name in Old for 2015's name
for (var in diff_case_vars) {
  master_var <- names_master[tolower(names_master) == tolower(var)]
  if (length(master_var) == 1) setnames(old_master, var, master_var[1]) #print(master_var[1]) 
}

##Bring Emplid to GPID file
Emplid_GPID <- read_datatable(paste(rawdata_path, "Emplid to GPID China India Brazil v6.xlsx", sep = '/') )
setnames(Emplid_GPID, gsub("\\.", "", names(Emplid_GPID)) )
Emplid_GPID[, c("Emplid") := NULL]
Emplid_GPID <- rename(Emplid_GPID, c("UNIQUEID" ="UniqueID"))
Emplid_GPID <- Emplid_GPID[!is_missing(UniqueID),]

old_master <- merge(x = old_master, y = Emplid_GPID, by = c('UniqueID'), all.x = TRUE)
rm(Emplid_GPID)

old_master[is_missing(RealGPID), RealGPID := GPID]

old_master <- rename(old_master, c("GPID"="GPID_OLD", "RealGPID" = "GPID"))

##sorted by ascending MostRecentHireDate to remove the older MRHireDate in case of duplicates
old_master<-old_master[order(GPID, Year, Country, Russia_Dups, -MostRecentHireDate)]
z <- find_dups(old_master, c("GPID", "Year", "Country", "Russia_Dups"))

##issues with dates :S old_master <- clean_dates_dt(old_master, 'SPSS')
old_master <- remove_dups(old_master, c("GPID", "Year", "Country", "Russia_Dups"))

save(old_master, file = paste(data_path, "old_master.RData", sep= '/'))

                     
#For India there were people who left between January and April 2015 who are not tracked in BO.
#They were manually pulled from EC and artifically included in the dataset.
MissingEEs <- old_master[Year == 2014 & 
                           (UniqueID %in% c(1021, 1053, 1109, 1185, 1194, 1243, 1446, 1471, 1488, 1587, 1628, 1634, 1793, 1838, 1847, 1866,
                                           2002, 2041, 2100, 2110, 2120, 2275, 2279, 2298, 2376, 2425, 2609, 2616, 2640, 2755, 2908, 2991, 3164, 3258, 3415, 3651, 3661, 3673, 3690,
                                           3699, 3710, 3716, 3725, 3749, 3820, 3848, 3850, 3853, 3959, 3961, 4053, 4065, 4192, 4195, 4214, 4225, 4234, 4238, 4248, 4256, 4275, 4321,
                                           4378, 4404, 4452, 4470, 4476, 4480, 4490, 4525, 4527, 4528, 4532, 4603, 61224, 61225, 61226, 61232, 61233, 61235, 61236, 61237, 61238,
                                           61242, 61243, 61244, 61089, 58021, 58022, 58026, 58027, 58030, 58031, 58035, 58036, 58038, 58043, 58047, 58051, 58056, 58057, 58063,
                                           58064, 88790, 88739, 88769, 88770, 88772, 88773, 88774, 88776, 88777, 88778, 88785, 88792, 88794, 59814, 88152, 87591, 88669, 47094,
                                           88629, 57959, 86346, 88663, 48098, 88682, 47093) |
                            Emplid %in% c('3295240066', '3200540360', '3266440556', '3197841718',
                                          '3074640666', '2332131107', '2632634456', '2639233298', '2398933298', '2404534456', '3217241884', '3435041379', '2619439356', '2416736770',
                                          '3337840827', '2636237865', '2932636558', '2823735844', '3254040360', '3088340556', '2389432264', '2134329556', '2572632629', '2377932143',
                                          '2249935537', '3198540570', '3089140610', '3050540558', '2902540150', '2739540175', '2789939814', '3132240066', '2445933298', '2328633298',
                                          '3211640066', '2375432143', '3238140154', '3176140556', '3304540595', '3214340581', '3230440294', '3237139814', '3150640556', '3459441579',
                                          '3242241590', '2911940848', '2445232144', '2353432295', '2517636552', '2228240848', '2917836547', '2719434912', '2311539531', '2652633008',
                                          '2385533008', '2566833008', '3360441745', '3282940549', '3340940739', '2898736750', '3198839790', '2501133817', '2485534731', '2041840848',
                                          '3282640175', '2320733298', '2602234477', '2578537865', '2724039783', '3336141884', '3196840057', '3360441508', '3217540649', '3287441884',
                                          '2747240848', '2870936165', '2387140848', '2581237664', '2137134786', '2692237645', '2694540848', '3378040739', '3163440106', '2159640848',
                                          '2138130956', '2125931048', '2616840848', '2815737928', '2905036982', '3470341772', '2905137029', '2427833298', '2992840655', '2493139755',
                                          '3152240142', '2684637008', '3284541024', '0409841024', '2805936547', '3047240142', '2971340066', '2113540848', '3087541745', '2904740248',
                                          '3281340066', '2841840848', '3163440066', '3177340268', '3162640057', '3280640754', '3293340931', '3204040871', '3120240740', '3047338768',
                                          '2571133390', '2617734285', '3460641347', '2393534731', '2291933298', '2350933298', '2444134060', '2724134744', '2334240848', '2235540848',
                                          '3282040749', '3181541379', '3148640142', '2844236526', '3249640582', '3340741508', '2741440848', '3133240106', '2907236514', '3121640304',
                                          '3376041631', '2762336558', '3202640120', '3369340711', '3288640658', '2731039472', '3073539576', '2861240658', '2402732883', '3233440739',
                                          '3090440574', '2204933390', '2744240848', '2571636423', '3256840310', '2710334731', '2921440142', '2666437865', '3232840330', '3068439518',
                                          '2664834834', '2082830020', '2317731784', '2709334464', '2352934508', '2561436234', '2563433298', '2739437029', '3156841884', '2528232264',
                                          '2644037645', '3232940106', '2447537987', '2666836444', '2761636549', '3220341520', '2832936965', '3141540592', '2672837865', '3228841884',
                                          '2656234456', '2719536288', '3397741888', '2025031048', '3291540558', '2657335004', '2499034090', '2563737641', '2651237928', '2937641884',
                                          '2937641508', '3291440273', '2936640057', '3335840739', '2787036188', '3340541631', '2829136963', '3372541354', '2759740848', '2480240848',
                                          '3063737865', '2928336558', '2949636558', '2410833241', '3229541508', '3262140618', '2776036558', '2629937729', '2452339708', '3148340556',
                                          '2701040277', '2810936188', '2216231660', '2648534456', '3188040057', '3249240316', '3193040556', '3028639797', '2666537649', '3324041051',
                                          '2949739600', '2379334464', '2723235485', '2448234456', '2758240848', '2585634731', '3445941718', '2456340320', '2934240142', '2495940848',
                                          '2809636436', '2827235537', '2531335524', '2389432905', '3269740658', '3234040239', '2717434720', '2722634720', '2394332515', '2536137928',
                                          '2508134456', '2733537716', '3194041508', '2563136558', '2160940848', '2946239518', '2893441052', '2663534060', '3008040430', '2616133147',
                                          '2119128611', '3176640057', '2526437716', '2601536206', '2965136588', '2995040057', '2474132149', '2604140238', '2712937865', '2598439986',
                                          '2062130195', '2403133008', '2382733298', '2791534687', '2438440834', '2615841214', '3300040882', '3131840655', '3232741884', '3196141508',
                                          '2752335524', '2376436498', '3180940310', '2460740848', '3196640179', '3093938217', '2996241094', '3177839885', '2928540232', '2862536967',
                                          '2167434731', '3168940931', '2168232568', '2837739600', '2616036444', '2338231868', '2095030225', '2402030996', '2102134731', '3226941508',
                                          '3226941884', '2791836816', '3043040198', '2556937928', '2265834731', '2675535844', '3388040582', '2374334731', '3051240057', '2557240848',
                                          '3193339848', '3337540525', '2888737865', '2494534954', '2827135537', '3041040280', '3195940154', '3334340266', '2841337865', '2360230483',
                                          '2719936188', '2393934764', '3195940556', '3031739472', '2552840890', '2932440848', '2914836404', '3185040664', '2958937865', '2919940848',
                                          '2900840848', '2577540231', '3220440057', '2749834912', '2887040848', '3070540310', '3084340106', '3393641949', '2680434731', '2687535933',
                                          '2482637546', '3305540763', '2590541122', '3122940574', '3379341775', '2995539600', '3279641318', '2999739832', '2407837648', '2571334456',
                                          '3032240618', '2575034456', '2826534720', '2389234456', '2680036924', '2481130996', '2354040848', '3052940087', '3169540310', '2861339888',
                                          '3230940582', '3177840558', '2642834060', '3214340574', '3382941348', '3343440582', '2867638429', '3068840681', '2926140078', '3287440535',
                                          '2474736206', '3248740066', '2579440879', '2369234720', '2313633298', '2572033008', '2776134687', '3031340057', '2835336846', '3196840675',
                                          '2624037716', '2797336423', '3053640656', '2440940848', '3028636774', '3062240549', '3233940546', '3069140441', '2231131548', '3269740066',
                                          '2133733298', '3029440295', '3050240302', '2430332387', '2535533604', '2752133646', '2499031420', '2754633008', '3228241008', '3036740294',
                                          '3124639814', '2867140848', '3041437008', '3261340266', '2870440848', '3178540535', '2692839787', '2846435478', '3104840201', '3270440264',
                                          '2284540848', '3189839874', '3337340882', '2759636963', '2338337683', '2885937007', '3261340546', '2782737865', '3251140882', '3000540066',
                                          '3244740232', '2760937865', '3017237865', '2438834456', '3130540313', '2747337928', '3036540584', '3306440675', '2871236770', '2511233606',
                                          '3075540795', '3100639545', '2739334060', '2562834759', '2868640848', '2945037104', '2902236588', '2538540848', '3336341345', '2832940687',
                                          '2491440238', '2630436963', '2867339797', '2676436589', '2861137928', '2303940848', '3011440679', '3160441694', '2426837716', '3419641960',
                                          '3377340749', '3066641508', '3184941884', '3409541884', '3181641410', '3149940063', '2593537144', '3166040535', '2822236986', '2804136558',
                                          '2697640848', '2428940848', '3041640912', '2088934731', '2725540848', '2455137645', '2868938056', '3109240150', '2797138139', '3002340645',
                                          '2688440848', '2673436558', '2918440848', '3197040066', '3083640279', '2318537641', '2429340848', '2528933298', '3043840645', '2521836924',
                                          '2484437624', '2668336467', '2630536188', '2791736558', '2830836816', '2088034731', '2411333298', '2389337865', '2883536558', '2929536514',
                                          '2393831780', '2270634836', '3242240360', '3242140360', '2830937865', '2133733008', '2481733246', '2353430996', '2557537928', '2257933008',
                                          '2433033008', '2645533241', '3269940560', '2976836846', '3231141883', '3273240317', '2961637032', '3179940534', '3315640592', '3220740584',
                                          '3211640749', '3304441884', '3282440574', '3252541351', '3414541884', '2508734060', '2753935544', '2778840848', '0355240828', '3226940280',
                                          '2855440848', '3221041370', '2684740848', '3268441883', '3227741324', '2837234254', '2165834464', '2956837865', '3005040592', '2867940308',
                                          '3123839814', '2582540848', '3269040150', '3269140574', '2514134274', '2794136188', '2791940848', '3150441884', '3150441508', '2944141884',
                                          '2944141508', '2666836188', '2922837014', '3200440066', '2711640848', '2532432264', '2650133298', '3203440546', '3188540320', '3358241884',
                                          '3358241508', '3090840239', '3087840320', '2919940556', '2611036211', '2849736588', '2469340649', '3039540304', '2884941585', '3082440645',
                                          '3272140175', '3134040666', '2814234867', '2949536514', '2783436514', '3068940582', '3068540316', '2844940848', '2684540284', '3118741884',
                                          '3118741508', '2576135553', '2399134731', '2973836557', '3181840582', '2816535537', '2474934456', '2172234456', '2615035524', '2632936281',
                                          '2688740672', '2831135537', '2570934456', '2695635708', '3155240320', '3235640574', '2873839165', '3158840274', '2727736227', '2762234898',
                                          '3163139814', '2479537928', '2935940343', '3062141746', '2499136547', '3262340649', '3203040142', '3133440142', '2905140848', '2231134764',
                                          '2316334844', '2805840848', '2375733298', '2887036514', '2465434731', '3512941579', '3318840273', '3088339814', '2192737641', '2372130513',
                                          '2686233241', '3096040595', '2438334274', '2461840848', '2790534464', '2682535287', '2805936918', '2554237865', '3412541884', '2174637645',
                                          '3412541508', '2466940269', '2982940669', '3157340106', '3247540066', '2974740848', '3053240941', '3196340210', '2909941508', '2909941884',
                                          '3231841884', '3084840389', '3330341739', '2892939755', '2835236963', '2695137865', '2340729983', '3254440570', '2609133008', '3339341275',
                                          '2343237645', '2682036105', '2680836816', '2776736188', '2723040848', '2885340242', '3126540238', '3206640238', '2156529587', '3253339874',
                                          '2725236570', '2648140848', '2818636899', '2860037334', '2916936547', '3127840624', '2534334731', '3047740067', '2695740848', '2435433008',
                                          '2597934456', '3076640087', '3192841505', '2805336973', '2622333390', '2657736188', '2755036906', '3200740681', '2745840219', '2455137865',
                                          '2535533008', '2785136990', '3047140221', '3202341508', '3267140931', '2529140848', '3084541884', '2611638050', '3160740544', '2425932143',
                                          '2644434720', '2555635537', '2661840584', '2505140848', '2339330376', '2499032509', '3107240558', '2633633008', '2861441365', '3324340066',
                                          '2947540665', '2831137008', '3229940864', '2730637641', '3345440618', '2980136423', '3012239475', '2581240848', '2426732149', '2816436526',
                                          '3019739814', '3001540556', '3184540961', '3299641720', '2830736965', '2181133298', '2535334456', '2100232143', '2155729623', '314M0', '1348M0',
                                          '1497M0', '1583M0', '1602M0', '1607M0', '1622M0', '1641M0', '1692M0', '2162M0', '1762M0', '1763M0', '1765M0', '1769M0', '1778M0', '1883M0',
                                          '1891M0', '1913M0', '1921M0', '1960M0', '1965M0', '1992M0', '1995M0', '1999M0', '2013M0', '2014M0', '2024M0', '2035M0', '2066M0', '2077M0',
                                          '2092M0', '2104M0', '2130M0', '2141M0', '2177M0', '2182M0', '2188M0', '2202M0', '2204M0', '2215M0', '2217M0', '2231M0', '2270M0', '2271M0',
                                          '2272M0', '2273M0', '2274M0', '2275M0', '2276M0', '2277M0', '2278M0', '2279M0', '2281M0', '2283M0', '2284M0', '3974M0', '3975M0', '3976M0',
                                          '3981M0', '3982M0', '3984M0', '3985M0', '3986M0', '3987M0', '3990M0', '3991M0', '3992M0', '6409M0', '12339M0', '13284M0', '13599M0', '13767M0',
                                          '14333M0', '3845M0', '16759M0', '17126M0', '17868M0', '18105M0', '18168M0', '19029M0', '19168M0', '19277M0', '19922M0',
                                          '20150M0', '20153M0', '20213M0', '20230M0', '20457M0', '20611M0', '20612M0', '20613M0', '20617M0', '20618M0', '20620M0', '20621M0', '20625M0',
                                          '20626M0', '20628M0', '20632M0', '20637M0', '20641M0', '20647M0', '20649M0', '20654M0', '20655M0', '403182M0', '404027M0', '406854M0', '406196M0',
                                          '406797M0', '406579M0', '406634M0', '406734M0', '406831M0', '406832M0', '406834M0', '406835M0', '406836M0', '406838M0', '406839M0', '406840M0',
                                          '406849M0', '406856M0', '406858M0', '20334M0', '18909M0', '19848M0', '20204M0', '20476M0', '20477M0', '401622M0', '406715M0', '20507M0', '16600M0',
                                          '20438M0', '20564M0', '20565M0', '404878M0', '405277M0', '406688M0', '406671M0', '3563M0', '19938M0', '3500M0', '406783M0', '15619M0', '17738M0',
                                          '14131M0', '20238M0', '19507M0', '20484M0', '406518M0', '2588M0', '19885M0', '406679M0', '19994M0', '17430M0', '2091M0', '20470M0', '404902M0',
                                          '2175M0', '20421M0', '20365M0', '20516M0', '406129M0', '20016M0', '406398M0', '406776M0', '406746M0', '18198M1', '14815M0', '14998M0', '15834M0',
                                          '19909M0', '403474M0', '405801M0', '19743M0', '406713M0', '1594M0', '404483M0', '3899M0', '406360M0', '2003M0', '406546M0', '20224M0', '3909M0',
                                          '173M1', '406764M0', '19741M0', '3762M0', '406534M0', '406430M0', '12548M0', '1413M0', '19870M0', '19966M0', '20318M0', '20402M0', '20430M0',
                                          '20557M0', '406594M0', '938M1', '401529M0', '405161M0', '406184M0', '403559M0', '20320M0', '620M1', '406183M0', '19937M0', '14576M0', '3869M0',
                                          '15224M0', '3964M0', '15097M0', '406706M0', '18796M0', '20580M0', '14105M0', '14150M0', '20374M0', '403565M0', '20149M0', '20053M0', '404265M0',
                                          '19360M0', '406458M0', '18331M0', '403789M0', '16307M0', '3786M0', '404402M0', '20456M0', '20493M0', '20279M0', '406573M0', '402022M0', '15669M0',
                                          '20252M0', '3908M0', '19048M0', '406102M0', '1623M0', '20511M0', '13109M0', '1918M0', '1481M0', '1706M0', '2226M0', '3732M0', '405046M0', '2010M0',
                                          '1370M0', '19766M0', '20396M0', '406824M0', '15832M0', '18753M0', '20237M0', '20335M0', '2086M0', '404014M0', '19660M0', '20506M0', '20599M0',
                                          '3920M0', '406786M0', '1698M0', '3937M0', '146M0', '406617M0', '20563M0', '3787M0', '405327M0', '9414M0', '17470M0', '18789M0', '19777M0',
                                          '17853M0', '18993M0', '406386M0', '406510M0', '3722M0', '19414M0', '406544M0', '19428M0', '20546M0', '3860M0', '406091M0', '406543M0',
                                          '18576M0', '1874M0', '16018M0', '18301M0', '1817M0', '20208M0', '19977M0', '20585M0', '401453M0', '19798M0', '403486M0', '13372M0', '1870M0',
                                          '406810M0', '18358M0', '3938M0', '406508M0', '20481M0', '14597M0', '15497M0', '2041M0', '1248M0', '19287M0', '18213M0', '3772M0', '3785M0',
                                          '406664M0', '20210M0', '16916M0', '13714M0', '2154M1', '20441M0', '20254M0', '1493M0', '13859M0', '20211M0', '12976M0', '404914M0',
                                          '18115M0', '1900M0', '401767M0', '15421M0', '19077M0', '406498M0', '19140M0', '405711M0', '406507M0', '406592M0', '1975M0', '20467M0',
                                          '401060M0', '19457M0', '20485M0', '16011M0', '20534M0', '406540M0', '12841M0', '404617M0', '20272M0', '406390M0', '20273M0', '20310M0',
                                          '15045M0', '2263M0', '20514M0', '20486M0', '19653M0', '19730M0', '20241M0', '3790M0', '19147M0', '20451M0', '15508M0', '19817M0', '20212M0',
                                          '2619M0', '17973M0', '3942M0', '404341M0', '19727M0', '406539M0', '14893M0', '709M2', '405699M0', '20549M0', '20021M0', '406547M0', '406720M0',
                                          '19091M0', '2185M0', '405542M0', '2214M0', '13429M0', '405320M0', '963M0', '406711M0', '2080M0', '404629M0', '19368M0', '20214M0', '19241M0',
                                          '15367M0', '20501M0', '1296M0', '405411M0', '17767M0', '406328M0', '1484M0', '19431M0', '406637M0', '406732M0', '3902M0', '1901M0', '19872M0',
                                          '401191M0', '7834M0', '12197M0', '14151M0', '14941M0', '18932M0', '3832M0', '999M0', '1575M0', '2051M0', '2131M0', '15238M0', '19882M0', '19812M0',
                                          '3771M0', '406298M0', '18305M0', '20383M0', '16357M0', '403521M0', '18970M0', '402470M0', '19604M0', '19795M0', '20425M0', '18440M0', '1986M0',
                                          '16956M0', '20593M0', '20608M0', '20124M0', '19619M0', '2090M0', '20573M0', '939M2', '18134M0', '19469M0', '20192M0', '2262M0', '18237M0',
                                          '14352M0', '3960M0', '18441M0', '19894M0', '20025M0', '404873M0', '12894M0', '2096M0', '16205M0', '20543M0', '3691M1', '12365M0', '16206M0',
                                          '19952M0', '12646M0', '1840M0', '13026M0', '405518M0', '12580M0', '12607M0', '2899M0', '18974M0', '1134M0', '2234M0', '406266M0', '1928M0',
                                          '20369M0', '405921M0', '1398M0', '403801M0', '404927M0', '20244M0', '20346M0', '2103M0', '405365M0', '20577M0', '15256M0', '19962M0', '13973M0',
                                          '20522M0', '406249M0', '20030M0', '3225M0', '3971M0', '20327M0', '17421M0', '1821M0', '3791M0', '18723M0', '3801M0', '13466M0', '20526M0',
                                          '20527M0', '406756M0', '15083M0', '19401M0', '406639M0', '19665M0', '1219M0', '404111M0', '3912M0', '1162M0', '2019M0', '20282M0', '20101M0',
                                          '15448M0', '1070M1', '20283M0', '17243M0', '3647M1', '18325M0', '402058M0', '13976M0', '406799M0', '19263M0', '18218M0', '406551M0', '406787M0',
                                          '405634M0', '18477M0', '18975M0', '5970M0', '406351M0', '402803M0', '406155M0', '17262M0', '3838M0', '7720M0', '15166M0', '2136M0', '406604M0',
                                          '406642M0', '19901M0', '1090M1', '406784M0', '3928M0', '20181M0', '406661M0', '1984M0', '406667M0', '3633M0', '406795M0', '2148M0', '19473M0',
                                          '20532M0', '19929M0', '406482M0', '19548M0', '20466M0', '19490M0', '16456M0', '20015M0', '2062M0', '406807M0', '19339M0', '20271M0', '1568M0',
                                          '1624M0', '1146M0', '17205M0', '19336M0', '18097M0', '2075M0', '20586M0', '1781M0', '406761M0', '3932M0', '17701M0', '20567M0', '406226M0',
                                          '19802M0', '3895M0', '2268M0', '406149M0', '20536M0', '17609M0', '20442M0', '406707M0', '3833M0', '402995M0', '17760M0', '16984M0', '406542M0',
                                          '405863M0', '19585M0', '20589M0', '19750M0', '19302M0', '19533M0', '2128M0', '3917M0', '406549M0', '19595M0', '654M0', '400233M0', '2207M0',
                                          '406114M0', '404004M0', '406377M0', '1947M0', '20568M0', '1390M0', '1894M0', '2253M0', '2839M0', '403941M0', '1743M0', '1320M0', '401765M0',
                                          '16853M0', '20552M0', '1617M0', '8402M0', '20540M0', '3798M0', '2150M0', '1466M0', '18590M0', '18887M0', '2061M0', '2280M0', '20315M0', '1746M0',
                                          '19416M0', '20368M0', '2153M0', '20225M0', '19939M0', '2285M0', '18246M0', '19749M0', '19903M0', '15723M0', '16997M0', '2241M0', '2109M0', '3896M0',
                                          '20458M0', '401040M0', '19772M0', '406710M0', '20495M0', '2108M0', '18635M0', '19662M0', '19616M0', '405721M0', '406350M0', '174M0', '401289M0',
                                          '405869M0', '2044M0', '3338M0', '20309M0', '404213M0', '405118M0', '2094M0', '20018M0', '20229M0', '20544M0', '1673M0', '400206M0', '1618M0',
                                          '404606M0', '601M1', '405246M0', '2069M0', '1663M0', '18701M0', '2919M0', '403111M0', '402316M0', '406646M0', '406805M0', '20344M0', '15049M0',
                                          '1574M0', '2095M0', '20531M0', '1991M0', '18179M0', '20156M0', '17383M0', '403653M0', '9364M0', '20294M0', '2184M0', '405716M0', '2137M0', '406516M0',
                                          '406154M0', '406808M0', '2055M0', '406809M0', '3775M0', '3086M0', '19948M0', '17025M0', '1703M0', '406751M0', '19959M0', '19297M0', '406676M0',
                                          '406658M0', '20480M0', '20286M0', '406656M0', '1681M0', '2115M0', '20265M0', '2045M0', '403949M0', '3736M0', '2193M0', '20412M0', '405864M0',
                                          '20158M0', '20474M0', '13862M0', '3963M0', '3989M0', '406829M0', '406830M0', '406833M0', '406857M0', '20619M0', '20652M0', '2654M0', '406140M0',
                                          '405540M0', '406714M0', '15798M0', '406673M0', '20556M0', '404199M0', '406708M0', '16753M0', '406730M0', '15797M0'))
                         ]

MissingEEs[, Year:=2015]
MissingEEs[, JHSAPStatus:='Withdrawn']
MissingEEs[, TERMINATIONREASON:='Other']
MissingEEs[, TermDate:= as.Date(paste("1/2/", Year), format = "%d/%m/%Y")]
MissingEEs[, STAT_Active:=0]
MissingEEs[, STAT_Term:=1]
MissingEEs[, Hire:=0]
MissingEEs[, ReHire:=0]
MissingEEs[, Turnover:=1]
MissingEEs[, Turnover_tmp:=1]
MissingEEs[, Turn_Vol:=0]
MissingEEs[, Turn_Invol:=0]
MissingEEs[, Turn_Other:=1]
MissingEEs[, Turn_OtherBIG:=1]
MissingEEs[, DataAsOfDate:= as.Date(paste("31/12/", Year), format = "%d/%m/%Y")]
MissingEEs[, Age:= as.double(difftime(DataAsOfDate, BirthDate, units = "days"))/ 365.25]
MissingEEs[, TenureOrig:= as.double(difftime(DataAsOfDate, OriginalHireDate, units = "days"))/ 365.25]
MissingEEs[, TenureMR:= as.double(difftime(DataAsOfDate, MostRecentHireDate, units = "days"))/ 365.25]
MissingEEs[, TenureServ:= as.double(difftime(DataAsOfDate, ServiceAwardDate, units = "days"))/ 365.25]
MissingEEs[, TenureBand:= as.double(difftime(DataAsOfDate, JHBandGradeEntryDate, units = "days"))/ 365.25]
MissingEEs[, TenureJob:= as.double(difftime(DataAsOfDate, JHPositionJobCodeEntryDate, units = "days"))/ 365.25]
MissingEEs[, Year_Other:=0]
MissingEEs[, Year_2008:=0]
MissingEEs[, Year_2009:=0]
MissingEEs[, Year_2010:=0]
MissingEEs[, Year_2011:=0]
MissingEEs[, Year_2012:=0]
MissingEEs[, Year_2013:=0]
MissingEEs[, Year_2014:=0]
MissingEEs[, Year_2015:=1]
MissingEEs[, Status:='Terminated']
MissingEEs[, EngageAvg:=0]
MissingEEs[, EngageAvg_Miss:=1]
MissingEEs[, CompIndex_Miss:=1]

save(MissingEEs, file = paste(data_path, "Missing Termed Ees v1_3.RData", sep= '/'))

##For India there were people who left between January and April 2015 who are not tracked in BO.
##They were manually pulled from EC and artifically included in the dataset.
MissingActiveEEs <- old_master[Year == 2014 & 
                           UniqueID %in% c(88824, 88887, 89203, 89441, 45215, 49341, 49639, 50162, 50666, 50721, 51135, 51168, 51190, 57747,
                                            58077, 58133, 58210, 58245, 58253, 58283, 59981, 61086, 89262, 44770, 45249, 46691, 49012, 50639, 50843, 51033,
                                            51125, 51356, 44417, 51655, 51720, 57847, 57919, 57985, 58005, 80676, 51650, 85203, 88599, 88706, 88708, 61030, 58121, 47789, 49043)
                            ]
                                            
MissingActiveEEs[, Year:=2015]
MissingActiveEEs[, JHSAPStatus:='Active']
MissingActiveEEs[, TERMINATIONREASON:='']
MissingActiveEEs[, STAT_Active:=1]
MissingActiveEEs[, STAT_Term:=0]
MissingActiveEEs[, Hire:=0]
MissingActiveEEs[, ReHire:=0]
MissingActiveEEs[, Turnover:=0]
MissingActiveEEs[, Turnover_tmp:=0]
MissingActiveEEs[, Turn_Vol:=0]
MissingActiveEEs[, Turn_Invol:=0]
MissingActiveEEs[, Turn_Other:=0]
MissingActiveEEs[, Turn_OtherBIG:=0]
MissingActiveEEs[, DataAsOfDate:= as.Date(paste("31/12/", Year), format = "%d/%m/%Y")]
MissingActiveEEs[, Age:= as.double(difftime(DataAsOfDate, BirthDate, units = "days"))/ 365.25]
MissingActiveEEs[, TenureOrig:= as.double(difftime(DataAsOfDate, OriginalHireDate, units = "days"))/ 365.25]
MissingActiveEEs[, TenureMR:= as.double(difftime(DataAsOfDate, MostRecentHireDate, units = "days"))/ 365.25]
MissingActiveEEs[, TenureServ:= as.double(difftime(DataAsOfDate, ServiceAwardDate, units = "days"))/ 365.25]
MissingActiveEEs[, TenureBand:= as.double(difftime(DataAsOfDate, JHBandGradeEntryDate, units = "days"))/ 365.25]
MissingActiveEEs[, TenureJob:= as.double(difftime(DataAsOfDate, JHPositionJobCodeEntryDate, units = "days"))/ 365.25]
MissingActiveEEs[, Year_Other:=0]
MissingActiveEEs[, Year_2008:=0]
MissingActiveEEs[, Year_2009:=0]
MissingActiveEEs[, Year_2010:=0]
MissingActiveEEs[, Year_2011:=0]
MissingActiveEEs[, Year_2012:=0]
MissingActiveEEs[, Year_2013:=0]
MissingActiveEEs[, Year_2014:=0]
MissingActiveEEs[, Year_2015:=1]
MissingActiveEEs[, Status:='Active']
MissingActiveEEs[, EngageAvg:=0]
MissingActiveEEs[, EngageAvg_Miss:=1]
MissingActiveEEs[, CompIndex_Miss:=1]

save(MissingActiveEEs, file = paste(data_path, "Missing Active Ees v1_3.RData", sep= '/'))


##ESSA SC Prior to 2015
essa_sc_old <- old_master[Country %in% c(5, 6, 8, 10) & Function == 12 & Level <8 & Emptype == 1,]

essa_sc_old[, Country_Turkey:=0]
essa_sc_old[, Country_Russia:=0]
essa_sc_old[, Country_UK:=0]
essa_sc_old[, Country_ESSA_SC:=1]
essa_sc_old[, Country_NAB_SC:=0]

essa_sc_old[, Flag:=1]

essa_sc_old[, InStudy_Turkey:=0]
essa_sc_old[, InStudy_Russia:=0]
essa_sc_old[, InStudy_RussiaPay:=0]
essa_sc_old[, InStudy_UK:=0]
essa_sc_old[, InStudy_ESSA_SC:=1]
essa_sc_old[, InStudy_Ukraine_CIS:=0]
essa_sc_old[, InStudy_All:=1]
essa_sc_old[, InStudy_AllPay:=1]
essa_sc_old[, InStudy_NAB_SC:=0]

essa_sc_old[, GPID := Emplid]

##Add old_master, essa_sc_old
load(file = paste(data_path, "master_2015.RData", sep = '/'))

master <- add_new_dataset(new_dt = MissingEEs, diffvars_meth = 2, old_dt = master)
rm(MissingEEs)

master <- add_new_dataset(new_dt = MissingActiveEEs, diffvars_meth = 2, old_dt = master)
rm(MissingActiveEEs)

master <- add_new_dataset(new_dt = essa_sc_old, Country_num = 9, diffvars_meth = 2, old_dt = master)
rm(essa_sc_old)

###########################################
save(master, file = paste(data_path, "a.RData", sep= '/'))
save(old_master, file = paste(data_path, "b.RData", sep= '/'))
load(file = paste(data_path, "a.RData", sep = '/'))
load(file = paste(data_path, "b.RData", sep = '/'))


master <- add_new_dataset(new_dt = old_master, diffvars_meth = 2, old_dt = master)
rm(old_master)

save(master, file = paste(data_path, "Grand Master SWP Dataset 4 30 2016 v1_4.RData", sep= '/'))
# load(file = paste(data_path, "master.RData", sep = '/'))

## Keep going 
master[is_missing(Russia_Dups), Russia_Dups := 1]

master[, Flag :=0] #remove this line
##sorted by ascending Flag to remove Flag=1 in case of duplicates
master<-master[order(Emplid, Year, Country, Russia_Dups, Flag)]
z <- find_dups(master, c("Emplid", "Year", "Country", "Russia_Dups"))

master <- remove_dups(master, c("Emplid", "Year", "Country", "Russia_Dups"))

master[Age_Miss == 1, Age := NA]
master[TenureMR_Miss == 1, TenureMR := NA]
master[TenureServ_Miss == 1, TenureServ := NA]
master[TenureBand_Miss == 1, TenureBand := NA]
master[TenureJob_Miss == 1, TenureJob := NA]

master[, Age_mean:= mean(Age) ]
master[, TenureMR_mean:= mean(TenureMR) ]
master[, TenureServ_mean:= mean(TenureServ) ]
master[, TenureBand_mean:= mean(TenureBand) ]
master[, TenureJob_mean:= mean(TenureJob) ]

master[Age_Miss == 1, Age := Age_mean]
master[TenureMR_Miss == 1, TenureMR := TenureMR_mean]
master[TenureServ_Miss == 1, TenureServ := TenureServ_mean]
master[TenureBand_Miss == 1, TenureBand := TenureBand_mean]
master[TenureJob_Miss == 1, TenureJob := TenureJob_mean]

master[, c('Age_mean', 'TenureMR_mean', 'TenureServ_mean', 'TenureBand_mean', 'TenureJob_mean') := NULL]

##AgeGroups
master[, Age_Grp := '']
master[Age_Miss == 1, Age_Grp := 'Missing']
master[is_missing(Age_Grp) & Age < 25, Age_Grp := '24 or less']
master[is_missing(Age_Grp) & Age < 30, Age_Grp := '25 to 29']
master[is_missing(Age_Grp) & Age < 35, Age_Grp := '30 to 34']
master[is_missing(Age_Grp) & Age < 40, Age_Grp := '35 to 39']
master[is_missing(Age_Grp) & Age < 45, Age_Grp := '40 to 44']
master[is_missing(Age_Grp) & Age < 50, Age_Grp := '45 to 49']
master[is_missing(Age_Grp) & Age < 55, Age_Grp := '50 to 54']
master[is_missing(Age_Grp) & Age < 100, Age_Grp := '55 or more']
master[Age_Grp == 'Missing', Age_Grp := '']

master[, Age_Grp2 := '']
master[Age_Miss == 1, Age_Grp2 := 'Missing']
master[is_missing(Age_Grp2) & Age < 26, Age_Grp2 := '25 or less']
master[is_missing(Age_Grp2) & Age < 29, Age_Grp2 := '26 to 28']
master[is_missing(Age_Grp) & Age < 32, Age_Grp2 := '29 to 31']
master[is_missing(Age_Grp2) & Age < 35, Age_Grp2 := '32 to 34']
master[is_missing(Age_Grp2) & Age < 38, Age_Grp2 := '35 to 37']
master[is_missing(Age_Grp2) & Age < 41, Age_Grp2 := '38 to 40']
master[is_missing(Age_Grp2) & Age < 46, Age_Grp2 := '41 to 45']
master[is_missing(Age_Grp2) & Age < 120, Age_Grp2 := '46 or more']
#master[Age_Grp2 == 'Missing', Age_Grp2 := '']


##TenureGroup
master[, Ten_Grp := '']
master[TenureMR_Miss == 1, Ten_Grp := 'Missing']
master[is_missing(Ten_Grp) & TenureMR < 1, Ten_Grp := '0 to lt1']
master[is_missing(Ten_Grp) & TenureMR < 3, Ten_Grp := '1 to 2']
master[is_missing(Ten_Grp) & TenureMR < 5, Ten_Grp := '3 to 4']
master[is_missing(Ten_Grp) & TenureMR < 8, Ten_Grp := '5 to 7']
master[is_missing(Ten_Grp) & TenureMR < 13, Ten_Grp := '8 to 12']
master[is_missing(Ten_Grp) & TenureMR < 60, Ten_Grp := '13 or more']
master[Ten_Grp == 'Missing', Ten_Grp := '']

##Create Dummy variables
master <- create_dummies2(master, 'Age_Grp', Threshold = 50)
master <- create_dummies2(master, 'Ten_Grp', Threshold = 50)

master[, City_CL_Miss := as.numeric(is_missing(CITY_CL))]

master[is_missing(Country_NAB_SC), Country_NAB_SC := 0] #check if there are missings -- also if there are missing for any country dummie
master[is_missing(Country_UK), Country_UK := 0]
master[is_missing(Country_ESSA_SC), Country_ESSA_SC := 0]
master[is_missing(Country_Ukraine_CIS), Country_Ukraine_CIS := 0]
master[is_missing(Turn_Churn), Turn_Churn := 0]
master[is_missing(Turn_Unknown), Turn_Unknown := 0]
master[is_missing(InStudy_NAB_SC), InStudy_NAB_SC := 0]
master[is_missing(InStudy_UK), InStudy_UK := 0]
master[is_missing(InStudy_ESSA_SC), InStudy_ESSA_SC := 0]
master[is_missing(InStudy_Ukraine_CIS), InStudy_Ukraine_CIS := 0]
master[, Year_2008 := 0] #remove this line
master[, Year_2009 := 0] #remove this line
master[is_missing(Year_2008), Year_2008 := 0]
master[is_missing(Year_2009), Year_2009 := 0]

master[, c('BeginofYear', 'EndofYear', 'TermYear', 'Turnover_tmp') := NULL]

master[, PayAnnRate_USD_FX_Miss := PayAnnRate_USD_FX_LN_Miss]
master[PayAnnRate_USD_FX_Miss == 1, PayAnnRate_USD_FX := 0 ]
master[PayAnnRate_USD_FX_LN_Miss == 1, PayAnnRate_USD_FX_LN := 0 ]

##Computwe Unique ID
master[, GPID := Emplid] #remove this line
master[, c('CompIndex_Miss', 'UniqueID') := NULL]
master[, UniqueID := GPID] #do we have GPID?

### "Fix" the CI under some rules

## 1. When only one of the two ratings is present, get it 
master[, CompIndex_v2 := rowMeans(cbind(BusinessRating,PeopleRating), na.rm=TRUE)]
master[is_missing(CompIndex_v2), CompIndex_v2 := NA]


master[, CompIndex_Miss := as.numeric(is_missing(CompIndex_v2))]
master[, CompIndex_mean:= mean(CompIndex_v2, na.rm=TRUE )]
master <- Lag_Vars(master, c('CompIndex_v2'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)

##2. When last year's CI is available, get it
master[is_missing(CompIndex_v2), CompIndex_v2 := CompIndex_v2_LAG1]

##3. When missing CI, get the avg CI of the whole population
master[is_missing(CompIndex_v2), CompIndex_v2 := CompIndex_mean]

master[, c('CompIndex_mean') := NULL]

master[, ci_high := as.numeric(CompIndex_v2 >= 4 & CompIndex_Miss == 0)]
master[, ci_low := as.numeric(CompIndex_v2 <= 2.5 & CompIndex_Miss == 0)]

# master[, ManagerGPID:=sprintf("%08d", as.character(ManagerGPID))] #check with old master 
master[nchar(ManagerGPID) < 8, ManagerGPID:=str_pad(ManagerGPID, width=8, side="left", pad="0")] #check this line/before
##Changes
master <- Lag_Vars(master, c('Level', 'Level_grp', 'Level_grp2', 'JHLocationDescription', 
                     'JHPositionJobCodeTitle', 'Function', 'CITY_CL', 'JHAnnualRate',
                     'ManagerGPID', 'JHCurrencyCode'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)

master[, TSM := 1] #check this line/before
master[, Promo:=0]
master[!is_missing(Level) & !is_missing(Level_LAG1) & Level > Level_LAG1, Promo:=1]
master[Country == 6 & Level == 7 & Level_LAG1 == 6 & Year %in% c(2014,2015) & TSM == 1, Promo := 0]

master[, Promo_big := as.numeric(!is_missing(Level_grp) & !is_missing(Level_grp_LAG1) & 
                                   Level_grp > Level_grp_LAG1)]

master[, Promo_big2 := as.numeric(!is_missing(Level_grp2) & !is_missing(Level_grp2_LAG1) & Level_grp2 > Level_grp2_LAG1)]

master[, Demo := as.numeric(!is_missing(Level) & !is_missing(Level_LAG1) & Level < Level_LAG1)]

master[, Demo_big := as.numeric(!is_missing(Level_grp) & !is_missing(Level_grp_LAG1) & 
                                  Level_grp < Level_grp_LAG1)]

master[, Demo_big2 := as.numeric(!is_missing(Level_grp2) & !is_missing(Level_grp2_LAG1) & 
                                   Level_grp2 < Level_grp2_LAG1)]


master[, LocChg := as.numeric(!is_missing(JHLocationDescription) & !is_missing(JHLocationDescription_LAG1) & JHLocationDescription != JHLocationDescription_LAG1)]

master[, JobChg := as.numeric(!is_missing(JHPositionJobCodeTitle) & !is_missing(JHPositionJobCodeTitle_LAG1) & JHPositionJobCodeTitle != JHPositionJobCodeTitle_LAG1)]

master[, ManagerGPIDChg := as.numeric(!is_missing(ManagerGPID) & !is_missing(ManagerGPID_LAG1) & ManagerGPID != ManagerGPID_LAG1)]

master[, FunctionChg := as.numeric(!is_missing(Function) & !is_missing(Function_LAG1) & Function != Function_LAG1)]

master[, CITY_CLChg := as.numeric(!is_missing(CITY_CL) & !is_missing(CITY_CL_LAG1) & CITY_CL != CITY_CL_LAG1)]

#Annual Rate Change
master[JHAnnualRate > 0 & JHAnnualRate_LAG1 > 0 & JHCurrencyCode == JHCurrencyCode_LAG1, AnnualRateChgPer := (JHAnnualRate-JHAnnualRate_LAG1) / JHAnnualRate_LAG1]

master[, AnnualRateChgPer_Miss := as.numeric(is_missing(AnnualRateChgPer) | AnnualRateChgPer < 0 | AnnualRateChgPer > 0.5)]

master[, AnnualRateChgPer_v2 := pmin(pmax(AnnualRateChgPer,0), 0.5)]
#master[, AnnualRateChgPer_v2 := AnnualRateChgPer]
#master[AnnualRateChgPer_v2 <0, AnnualRateChgPer_v2 := 0]
#master[AnnualRateChgPer_v2 >0.5, AnnualRateChgPer_v2 := 5]

master[, AnnualRateChgPer_v2_Miss := as.numeric(is_missing(AnnualRateChgPer_v2))]

master[AnnualRateChgPer_v2_Miss == 1, AnnualRateChgPer_v2 := 0]


##Create the Lead and Lag vars for modeling and descriptive analysis
##CriticalJob/Type not there
master[, CriticalJob := 0] #check this line/before
master[, Critical_Type := ''] #check this line/before

master <- Lead_Vars(master, c('Promo', 'Promo_big', 'Promo_big2', 'Demo', 'Demo_big', 'Demo_big2', 
                              'Turnover', 'Turn_Vol', 'Turn_Invol', 'Turn_Other', 'Turn_Churn', 'Turn_Unknown', 'Turn_OtherBIG',
                              'STAT_Active', 'STAT_Term', 'STAT_LV', 'ci_high', 'ci_low'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)
master <- Lag_Vars(master, c('Promo', 'Promo_big', 'Promo_big2', 'Demo', 'Demo_big', 'Demo_big2', 
                             'ci_high', 'ci_low', 'CriticalJob', 'STAT_Active', 'STAT_Term', 'Critical_Type'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)
# master <- Lag_Vars(master, c('Promo', 'Promo_big', 'Promo_big2', 'Demo', 'Demo_big', 'Demo_big2', 
#                              'ci_high', 'ci_low', 'STAT_Active', 'STAT_Term'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)


master[Year == 2015 & is_missing(Critical_Type), Critical_Type := Critical_Type_LAG1]
master[Year == 2015 & is_missing(CriticalJob), CriticalJob := CriticalJob_LAG1]
master[is_missing(CriticalJob), CriticalJob := 0]


##Education
EDU <- read_datatable(paste(rawdata_path, "L1+ BO EDU.xlsx", sep = '/') )

EDU[, c('DEGREE') := NULL]
master <- merge(x = master, y = EDU, by = c('GPID'), all.x = TRUE)

rm(EDU)

master[, EduLvl := 0] #remove this line
master[EDU_LVL %in% c('GRAD', 'GRADUATE', 'MASTERS', 'MBA IN GENERAL MANAGEMENT'), EDU_TMP2 := 4]
master[EDU_LVL %in% c('BACH', 'BACHELOR'), EDU_TMP2 := 3]
master[EDU_LVL %in% c('HIGH SCHOOL DIPLOMA', 'HS'), EDU_TMP2 := 2]

master[, EDU_TMP3 := pmax(EduLvl, EDU_TMP, EDU_TMP2)] ##check with old

master[, c('EduLvl_MISS', 'EduLvl_Graduate', 'EduLvl_Bachelor', 'EduLvl_Assoc', 'EduLvl_HS',
           'EduLvl_LtHS', 'EDU_LVL', 'EDU_TMP', 'EduLvl', 'EDU_TMP2') := NULL]

master <- rename(master, c("EDU_TMP3"="EduLvl"))
                 
master <- Lead_Vars(master, c('EduLvl'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)
master <- Lag_Vars(master, c('EduLvl'), c('GPID', 'Country', 'Russia_Dups'), 'Year', 1)

master[, EduLvl := coalesce2(EduLvl, EduLvl_LAG1, EduLvl_LEAD1)]

edu_labels = c('LT High School', 'High School', 'Associate', 'Bachelor', 'Graduate')
edu_levels = c(1,2,3,4,5)
master$EduLvl_label <- factor(master$EduLvl, levels = edu_levels, labels = edu_labels)

master[, EduLvl_MISS := as.numeric(is_missing(EduLvl))]

master[, EduLvl_Graduate := as.numeric(EduLvl == 5)]
master[, EduLvl_Bachelor := as.numeric(EduLvl == 4)]
master[, EduLvl_Assoc := as.numeric(EduLvl == 3)]
master[, EduLvl_HS := as.numeric(EduLvl == 2)]
master[, EduLvl_LtHS := as.numeric(EduLvl == 1)]
     
##WorkGroup


cc_num <- as.data.table(sort(unique(master$JHCostCenter))) #get unique Cost Centers
setnames(cc_num, 'JHCostCenter')
# cc_num[substring(JHCostCenter, 1, 1) != '*', JHCostCenter := paste(' ', JHCostCenter)]
cc_num$WorkGroup<-seq.int(nrow(cc_num))-1 +1 #the last +1 is to start at 1 (0 is for blanks)
master <- merge(x = master, y = cc_num, by = c('JHCostCenter'), all.x = TRUE)
rm(cc_num)

mg_num <- as.data.table(sort(unique(master$ManagerGPID))) #get unique Cost Centers
setnames(mg_num, 'ManagerGPID')
mg_num$WorkGroup_tmp<-seq.int(nrow(mg_num))-1 + 20000 +1 #the last +1 is to start at 1 (0 is for blanks)
master <- merge(x = master, y = mg_num, by = c('ManagerGPID'), all.x = TRUE)
rm(mg_num)

master[is_missing(WorkGroup), WorkGroup := WorkGroup_tmp] #check if Workgroup = 0 is the same as SPSS
# master[WorkGroup == 20000, WorkGroup := NA]
 master[, c("WorkGroup_tmp") := NULL]

##critical step -check in depth
agg_workgrp = master[InStudy_AllPay == 1, .(WorkGrpTenure_Mean= mean(TenureMR, na.rm = TRUE),
                            WorkGrp_HC = uniqueN(UniqueID), WorkGrpCI_Mean = mean(CompIndex_v2, na.rm = TRUE), 
                            WorkGrpPromo_Sum = sum(Promo), WorkGrpTurnover_Sum = sum(STAT_Term), 
                            WorkGrpActive_Sum = sum(STAT_Active)), 
                     by = .(WorkGroup, Year)]

master <- merge(x = master, y = agg_workgrp, by = c('WorkGroup', 'Year'), all.x = TRUE)

master[WorkGrpActive_Sum > 0, WorkGrpTurnoverRate := WorkGrpTurnover_Sum / WorkGrpActive_Sum]
master[WorkGrpActive_Sum > 0, WorkGrpPromoRate := WorkGrpPromo_Sum / WorkGrpActive_Sum]

####OHS VARIABLES

master[Age < 25, AgeGrp_OHS := 1]
master[Age >= 25 & Age < 30, AgeGrp_OHS := 2]
master[Age >= 30 & Age < 35, AgeGrp_OHS := 3]
master[Age >= 35 & Age < 40, AgeGrp_OHS := 4]
master[Age >= 40 & Age < 45, AgeGrp_OHS := 5]
master[Age >= 45 & Age < 50, AgeGrp_OHS := 6]
master[Age >= 50 & Age < 55, AgeGrp_OHS := 7]
master[Age >= 55 & Age < 60, AgeGrp_OHS := 8]
master[Age >= 60 & Age < 65, AgeGrp_OHS := 9]
master[Age >= 65 & Age < 70, AgeGrp_OHS := 10]
master[Age >= 70, AgeGrp_OHS := 11]

master[TenureMR < 1, TenureGrp_OHS := 1]
master[TenureMR >= 1 & TenureMR <= 3, TenureGrp_OHS := 2]
master[TenureMR > 3 & TenureMR <= 5, TenureGrp_OHS := 3]
master[TenureMR > 5 & TenureMR <= 10, TenureGrp_OHS := 4]
master[TenureMR > 10, TenureGrp_OHS := 5]

master[Gender == "M", Gender_OHS := 1]
master[Gender == "F", Gender_OHS := 2]

master[Level %in% c(16, 15, 14, 13, 12), BandGrp_OHS := 1]
master[Level %in% c(10, 11), BandGrp_OHS := 2]
master[Level %in% c(8, 9), BandGrp_OHS := 3]
master[Level %in% c(6, 7), BandGrp_OHS := 4]
master[Level %in% c(4, 5), BandGrp_OHS := 5]
master[Level == 3, BandGrp_OHS := 6]
master[Level == 2, BandGrp_OHS := 7]
master[Level == 1, BandGrp_OHS := 8]
master[Level == 0, BandGrp_OHS := 9]


#Value Labels BandGrp_OHS 1 "B1Plus" 2 "L10-L11" 3 "L8-L9" 4 "L6-L7" 5 "L4-L5" 6 "L3" 7 "L2" 8 "L1" 9 "FL" -->¿?¿¿¿¿

###OHS 2009
OHS2009 <- read_datatable(paste(rawdata_path, "Datafile2009Mapped_ForPepsi.sav", sep = '/') )

OHS2009 <- trim.spaces_dt(OHS2009)
OHS2009[, Country := 0]
OHS2009[Level4Title %in% c( "CHINA BEVS", "CHINA FOODS"), Country := 1]
OHS2009[Level4Title %in% c("INDIA"), Country := 2]
OHS2009[Level4Title %in% c("MEXICO","PEPSICO BEVERAGES MEXICO PBM (PAULA SANTILLI)","PEPSICO MEXICO FOODS SUPPORT TEAM", "SABRITAS"), Country := 3]
OHS2009[Level4Title %in% c("BRAZIL"), Country := 4]
OHS2009[Level5Title %in% c("TURKEY"), Country := 5]
OHS2009[Level5Title %in% c("RUSSIA MU"), Country := 6]
OHS2009[Level5Title %in% c("UK"), Country := 8]

#Duplicate data from PAB SC
extras_pab <- OHS2009[Level2Title == "PAB" & FuncLvl4Title %in% c("SUPPLY CHAIN/OPERATIONS", "OPERATIONS/SUPPLY CHAIN")]
OHS2009 <- add_new_dataset(new_dt = extras_pab, Country_num = 7, diffvars_meth = 2, old_dt = OHS2009)

#Duplicate data from ESSA SC
extras_essa <- OHS2009[Level3Title == "EUROPE" & FuncLvl4Title %in% c("SUPPLY CHAIN/OPERATIONS", "OPERATIONS/SUPPLY CHAIN")]
OHS2009 <- add_new_dataset(new_dt = extras_essa, Country_num = 9, diffvars_meth = 2, old_dt = OHS2009)



##BandLevel Grp Var
OHS2009[Band_AMEA %in% c( 1, 2, 3, 4, 5), BandGrp_OHS := 1]
OHS2009[Band_AMEA == 6, BandGrp_OHS := 2]
OHS2009[Band_AMEA == 7, BandGrp_OHS := 3]
OHS2009[Band_AMEA == 8, BandGrp_OHS := 4]
OHS2009[Band_AMEA == 9, BandGrp_OHS := 5]
OHS2009[Band_AMEA == 10, BandGrp_OHS := 6]
OHS2009[Band_AMEA == 11, BandGrp_OHS := 7]
OHS2009[Band_AMEA == 12, BandGrp_OHS := 8]
OHS2009[Band_AMEA %in% c( 13, 14, 15), BandGrp_OHS := 9]

OHS2009[Band_SAF == 1, BandGrp_OHS := 1]
OHS2009[Band_SAF %in% c(2, 3), BandGrp_OHS := 2]
OHS2009[Band_SAF %in% c(4, 5), BandGrp_OHS := 3]
OHS2009[Band_SAF %in% c(6, 7), BandGrp_OHS := 4]
OHS2009[Band_SAF %in% c(8, 9), BandGrp_OHS := 5]
OHS2009[Band_SAF == 10, BandGrp_OHS := 6]
OHS2009[Band_SAF == 11, BandGrp_OHS := 7]
OHS2009[Band_SAF == 12, BandGrp_OHS := 8]
OHS2009[Band_SAF %in% c(13, 14, 15), BandGrp_OHS := 9]

OHS2009 <- rename(OHS2009, c("AgeGrp" = "AgeGrp_OHS", "TenureGrp" = "TenureGrp_OHS", 
                             "Gender" = "Gender_OHS"))
OHS2009[, Year:= 2009]




##Create engagement index
#In 2011 --> Q021=Q022 and Q022=Q023
OHS2009[, Q021rev := 6- Q022]
OHS2009[, Q022rev := 6- Q023]



##In 2011 --> Q017=Q018, Q029=Q030, Q031=Q030, Q039=Q042, and Q071=Q075 <---???????
OHS2009 <- OHS2009[Country !=0 & !is_missing(AgeGrp_OHS) & !is_missing(Gender_OHS) 
                   & !is_missing(TenureGrp_OHS) & !is_missing(Level), ]

OHS2009[, engage:= rowMeans(cbind(Q018,Q021rev,Q022rev,Q030,Q031,Q042,Q075), na.rm=TRUE) ]

OHS2009 <- OHS2009[, .(Year, Country, Gender_OHS, BandGrp_OHS, AgeGrp_OHS, TenureGrp_OHS, engage)]
##do keep better?

save(OHS2009, file = paste(data_path, "OHS_2009.sav", sep= '/'))

# OHS2009[, Engageavg_2009 := mean(engage), by = .(Year, Country, Gender_OHS, BandGrp_OHS, AgeGrp_OHS, TenureGrp_OHS)]
# 
# OHS2009[, c("engage") := NULL]
# 
# OHS2009 <- remove_dups(OHS2009, c('Year', 'Country', 'Gender_OHS', 'BandGrp_OHS', 'AgeGrp_OHS',
#                                     'TenureGrp_OHS'))
OHS2009 <- OHS2009[, .(Engageavg_2009 = mean(engage, na.rm = TRUE)), by = .(Year, Country, Gender_OHS, BandGrp_OHS, AgeGrp_OHS, TenureGrp_OHS)]


master <- merge(x = master, y = OHS2009, by = c('Year', 'Country', 'Gender_OHS', 'BandGrp_OHS', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)

###OHS 2010

OHS2009 <- rename(OHS2009, c("Engageavg_2009" = "Engageavg_2010") )
OHS2009[, Year:=2010]
master <- merge(x = master, y = OHS2009, by = c('Year', 'Country', 'Gender_OHS', 'BandGrp_OHS', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)
rm(OHS2009)

###OHS 2011
OHS2011 <- read_datatable(paste(rawdata_path, "Datafile2011Mapped_ForPepsi.sav", sep = '/') )
OHS2011 <- trim.spaces_dt(OHS2011)

OHS2011[, c("Level") := NULL]
OHS2011[, Country := 0]
OHS2011[LocationCountry == "CN" , Country := 1]
OHS2011[LocationCountry == "IN" , Country := 2]
OHS2011[LocationCountry == "MX" , Country := 3]
OHS2011[LocationCountry == "BR" , Country := 4]
OHS2011[LocationCountry == "TR" , Country := 5]
OHS2011[LocationCountry == "RU" , Country := 6]
OHS2011[LocationCountry == "GB" , Country := 8]
OHS2011[LocationCountry %in% c("UA", "KZ", "KY") , Country := 10]

#Duplicate data from PAB SC
extras_pab <- OHS2011[Sector == "PBC" & (FuncLevel2Title == "OPERATIONS/SUPPLY CHAIN" | JobCatLevel3Title %in% c("OPERATIONS","SUPPLY CHAIN")),]
OHS2011 <- add_new_dataset(new_dt = extras_pab, Country_num = 7, diffvars_meth = 2, old_dt = OHS2011)

#Duplicate data from ESSA SC
extras_essa <- OHS2011[Sector == "EUROPE" &  (FuncLevel2Title == "OPERATIONS/SUPPLY CHAIN" | JobCatLevel3Title %in% c("OPERATIONS","SUPPLY CHAIN")),]
OHS2011 <- add_new_dataset(new_dt = extras_essa, Country_num = 9, diffvars_meth = 2, old_dt = OHS2011)


##Value Labels Country 0 "Other" 1 "China" 2 "India" 3 "Mexico" 4 "Brazil" 5 "Turkey" 6 "Russia" 7 "NAB SC" 8 "UK" 9 "ESSA SC"  10 "Ukraine & CIS".
OHS2011[Band_AMEA %in% c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20), Level :=  pmax(18- Band_AMEA, 0)]
OHS2011[Band_EUR  %in% c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57), Level :=  pmax(18- Band_EUR, 0)]

OHS2011[BandLvl ==  "B5", Level := 16]
OHS2011[BandLvl ==  "B4", Level := 15]
OHS2011[BandLvl ==  "B3", Level := 14]
OHS2011[BandLvl ==  "B2", Level := 13]
OHS2011[BandLvl ==  "B1", Level := 12]
OHS2011[BandLvl ==  "L11", Level := 11]
OHS2011[BandLvl ==  "L10", Level := 10]
OHS2011[BandLvl ==  "L9", Level := 9]
OHS2011[BandLvl ==  "L8", Level := 8]
OHS2011[BandLvl ==  "L7", Level := 7]
OHS2011[BandLvl ==  "L6", Level := 6]
OHS2011[BandLvl ==  "L5", Level := 5]
OHS2011[BandLvl ==  "L4", Level := 4]
OHS2011[BandLvl ==  "L3", Level := 3]
OHS2011[BandLvl ==  "L2", Level := 2]
OHS2011[BandLvl ==  "L1", Level := 1]
OHS2011[is_missing(BandLvl) & (Band_EUR > 17 | is_missing(Band_EUR) | Band_AMEA > 17 | is_missing(Band_AMEA) ), Level := 0]

OHS2011 <- rename(OHS2011 , c("AgeGrp" = "AgeGrp_OHS", "TenureGrp" = "TenureGrp_OHS", 
                             "Gender" = "Gender_OHS") )
OHS2011[, Year:= 2011]
                  
##Create engagement index
##In 2011 --> Q021=Q022 and Q022=Q023
OHS2011[,Q021rev := 6- Q022]
OHS2011[,Q022rev := 6- Q023]

##In 2011 --> Q017=Q018, Q029=Q030, Q031=Q030, Q039=Q042, and Q071=Q075
OHS2011 <- OHS2011[Country !=0 & !is_missing(AgeGrp_OHS) & !is_missing(Gender_OHS) & 
                     !is_missing(TenureGrp_OHS) & !is_missing(Level), ]

OHS2011[, engage:= rowMeans(cbind(Q018,Q021rev,Q022rev,Q030,Q031,Q042,Q075), na.rm=TRUE) ]

OHS2011 <- OHS2011[, .(Year, Country, Gender_OHS, Level, AgeGrp_OHS, TenureGrp_OHS, engage)]

save(OHS2011, file = paste(data_path, "OHS_2011.sav", sep= '/'))

OHS2011 <- OHS2011[, .(Engageavg_2011 = mean(engage, na.rm = TRUE)), by = .(Year, Country, Gender_OHS, Level, AgeGrp_OHS, TenureGrp_OHS)]


# OHS2011<- remove_dups(OHS2011, c('Year', 'Country', 'Gender_OHS', 'Level', 'AgeGrp_OHS',
#                                    'TenureGrp_OHS'))

master <- merge(x = master, y = OHS2011, by = c('Year', 'Country', 'Gender_OHS', 'Level', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)
###OHS 2012
OHS2011 <- rename(OHS2011, c("Engageavg_2011" = "Engageavg_2012"))
OHS2011[, Year:=2012]
master <- merge(x = master, y = OHS2011, by = c('Year', 'Country', 'Gender_OHS', 'Level', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)
rm(OHS2011)
                
###OHS 2013
OHS2013 <- read_datatable(paste(rawdata_path, "Pepsi2013_Data_121213.sav", sep = '/') )
OHS2013 <- rename(OHS2013 , c("Country" = "Country_OHS"))

OHS2013 <- trim.spaces_dt(OHS2013)

OHS2013[, Country := 0]
OHS2013[Country_OHS == "GREATER CHINA REGION (AMEA)",  Country := 1]
OHS2013[Country_OHS == "INDIA",  Country := 2]
OHS2013[Country_OHS == "MEXICO",  Country := 3]
OHS2013[Country_OHS == "BRAZIL",  Country := 4]
OHS2013[Country_OHS == "TURKEY",  Country := 5]
OHS2013[Country_OHS == "RUSSIA",  Country := 6]
OHS2013[Country_OHS == "UNITED KINGDOM",  Country := 8]
OHS2013[Country_OHS %in% c("UKRAINE", "KYRGYZSTAN", "AZERBAIJAN", "GEORGIA"),  Country := 10]

#Duplicate data from PAB SC
extras_pab <- OHS2013[Level2Title == "PAB" & FuncLevel2Title == "OPERATIONS/SUPPLY CHAIN",]
OHS2013 <- add_new_dataset(new_dt = extras_pab, Country_num = 7, diffvars_meth = 2, old_dt = OHS2013)

#Duplicate data from ESSA SC
extras_essa <- OHS2013[Level2Title == "EUROPE"  & FuncLevel2Title == "OPERATIONS/SUPPLY CHAIN",]
OHS2013 <- add_new_dataset(new_dt = extras_essa, Country_num = 9, diffvars_meth = 2, old_dt = OHS2013)

OHS2013[Band %in% c(1,2,3,4,5,6), Level :=  pmax(18- Band, 0)]
OHS2013[Band %in% c(9,10,11,12,13,14,15,16,17,18,19,20,36), Level :=  pmax(20- Band, 0)]
OHS2013 <- rename(OHS2013 , c("AgeGrp" = "AgeGrp_OHS", "Tenure" = "TenureGrp_OHS", 
                              "Gender" = "Gender_OHS"))
OHS2013[, Year:= 2013]

##Create engagement index
OHS2013[, Q021rev := 6 - Q021]
OHS2013[, Q022rev := 6 - Q022]

##In 2011 --> Q017=Q018, Q029=Q030, Q031=Q030, Q039=Q042, and Q071=Q075
OHS2013 <- OHS2013[Country !=0 & !is_missing(AgeGrp_OHS) & !is_missing(Gender_OHS) & 
                     !is_missing(TenureGrp_OHS) & !is_missing(Level), ]

OHS2013 <- OHS2013[, engage:= rowMeans(cbind(Q017,Q021rev,Q022rev, Q029,Q030,Q039,Q071), na.rm=TRUE)]

OHS2013 <- OHS2013[, .(Year, Country, Gender_OHS, Level, AgeGrp_OHS, TenureGrp_OHS, engage)]

save(OHS2013, file = paste(data_path, "OHS_2013.sav", sep= '/'))

OHS2013 <- OHS2013[, .(Engageavg_2013 = mean(engage, na.rm = TRUE)), by = .(Year, Country, Gender_OHS, Level, AgeGrp_OHS, TenureGrp_OHS)]

# OHS2013 [, c("engage") := NULL]

# OHS2013 <- remove_dups(OHS2013, c('Year', 'Country', 'Gender_OHS', 'Level', 'AgeGrp_OHS',
#                                    'TenureGrp_OHS'))

master <- merge(x = master, y = OHS2013, by = c('Year', 'Country', 'Gender_OHS', 'Level', 
                                                'AgeGrp_OHS','TenureGrp_OHS'), all.x = TRUE)
     
###OHS 2014
OHS2013 <- rename(OHS2013, c("Engageavg_2013" = "Engageavg_2014") )
OHS2013[, Year:=2014]
master <- merge(x = master, y = OHS2013, by = c('Year', 'Country', 'Gender_OHS','Level', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)
rm(OHS2013)

### 2015 DATA 
OHS2015 <- read_datatable(paste(rawdata_path, "2015_PepsiCo_OHS_WorkForceAnalytics.sav", sep = '/') )
OHS2015 <- rename(OHS2015, c("Country" = "Country_txt"))

OHS2015 <- trim.spaces_dt(OHS2015)

##Country Var
OHS2015[,Country := 0]
OHS2015[Country_txt == "Greater China (AMEA ONLY)",  Country := 1]
OHS2015[Country_txt == "India",  Country := 2]
OHS2015[Country_txt == "Mexico",  Country := 3]
OHS2015[Country_txt == "Brazil",  Country := 4]
OHS2015[Country_txt == "Turkey",  Country := 5]
OHS2015[Country_txt == "Russian Federation",  Country := 6]
OHS2015[Country_txt == "United Kingdom",  Country := 8]
OHS2015[Country_txt %in% c("Kazakhstan", "Ukraine", "Georgia", "Azerbaijan", "Kyrgyzstan") , Country := 10]
#Value Labels Country 0 "Other" 1 "China" 2 "India" 3 "Mexico" 4 "Brazil" 5 "Turkey" 6 "Russia" 7 "NAB SC" 8 "UK" 9 "ESSA SC" 10 "Ukraine & CIS".

#Duplicate data from PAB SC
extras_pab <- OHS2015[Demo39 ==  "PAB - Al Carey" & Demo41 == "OPERATIONS - 817000",]
OHS2015 <- add_new_dataset(new_dt = extras_pab, Country_num = 7, diffvars_meth = 2, old_dt = OHS2015)
rm(extras_pab)
#Duplicate data from ESSA SC
extras_essa <- OHS2015[Demo39 == "EUROPE" & Demo41 == "OPERATIONS - 817000",]
OHS2015 <- add_new_dataset(new_dt = extras_essa, Country_num = 9, diffvars_meth = 2, old_dt = OHS2015)
rm(extras_essa)

##BandLevel Grp Var
OHS2015[Demo1 %in% c("B06", "B05", "B04", "B03", "B02", "B01" ), BandGrp_OHS := 1]
OHS2015[Demo1 %in% c("L11", "L10"), BandGrp_OHS := 2]
OHS2015[Demo1 %in% c("L09", "L08"), BandGrp_OHS := 3]
OHS2015[Demo1 %in% c("L07", "L06"), BandGrp_OHS := 4]
OHS2015[Demo1 %in% c("L05", "L04"), BandGrp_OHS := 5]
OHS2015[Demo1  == "L03", BandGrp_OHS := 6]
OHS2015[Demo1  == "L02", BandGrp_OHS := 7]
OHS2015[Demo1  == "L01", BandGrp_OHS := 8]
OHS2015[Demo1  == "Hourly/Frontline", BandGrp_OHS := 9]

#Value Labels BandGrp_OHS 1 "B1Plus" 2 "L10-L11" 3 "L8-L9" 4 "L6-L7" 5 "L4-L5" 6 "L3" 7 "L2" 8 "L1" 9 "FL".
## AgeGrp
OHS2015[Demo14 == "Age 24 or Below",  AgeGrp_OHS := 1]
OHS2015[Demo14 == "Age 25-29",  AgeGrp_OHS := 2]
OHS2015[Demo14 == "Age 30-34",  AgeGrp_OHS := 3]
OHS2015[Demo14 == "Age 35-39",  AgeGrp_OHS := 4]
OHS2015[Demo14 == "Age 40-44",  AgeGrp_OHS := 5]
OHS2015[Demo14 == "Age 45-49",  AgeGrp_OHS := 6]
OHS2015[Demo14 == "Age 50-54",  AgeGrp_OHS := 7]
OHS2015[Demo14 == "Age 55-59",  AgeGrp_OHS := 8]
OHS2015[Demo14 == "Age 60-64",  AgeGrp_OHS := 9]
OHS2015[Demo14 == "Age 65-69",  AgeGrp_OHS := 10]
OHS2015[Demo14 == "Age 70+",  AgeGrp_OHS := 11]

##SELECT TENURE VAR
OHS2015[LengthofService == "Less than 1 year", TenureGrp_OHS := 1]
OHS2015[LengthofService == "1+ to 3 years", TenureGrp_OHS := 2]
OHS2015[LengthofService == "3+ to 5 years", TenureGrp_OHS := 3]
OHS2015[LengthofService == "5+ to 10 years", TenureGrp_OHS := 4]
OHS2015[LengthofService == "More than 10 years", TenureGrp_OHS := 5]

OHS2015[Sex ==  "Male", Gender_OHS := 1]
OHS2015[Sex ==  "Female", Gender_OHS := 2]

OHS2015[,Year := 2015]

##Create engagement index
OHS2015[,RCOM1 := 6 - COM1]
OHS2015[,RCOM2 := 6 - COM2]

OHS2015 <- OHS2015[Country !=0 & !is_missing(AgeGrp_OHS) & !is_missing(Gender_OHS) & 
                     !is_missing(TenureGrp_OHS) & !is_missing(BandGrp_OHS), ]

OHS2015[, engage := rowMeans(cbind(SAT2, LEI2, LEI1, RCOM1, RCOM2, SAT1, SAT3), na.rm=TRUE)]
OHS2015[, engage_new := rowMeans(cbind(SEI1, SEI2, SEI3), na.rm=TRUE)]
OHS2015 <- OHS2015[, .( Year, engage, engage_new, Country, Gender_OHS, AgeGrp_OHS, TenureGrp_OHS, BandGrp_OHS)]


OHS2015 <- OHS2015[, .(Engageavg_2015 = mean(engage, na.rm = TRUE), Engageavgnew_2015 = mean(engage_new, na.rm = TRUE) ), 
                   by = .(Year, Country, Gender_OHS, BandGrp_OHS, AgeGrp_OHS, TenureGrp_OHS)]
# OHS_2015[, c("engage", "engage_new") := NULL]

save(OHS2015, file = paste(data_path, "OHS_2015.sav", sep= '/'))


# OHS_2015<- remove_dups(OHS_2015, c('Year', 'Country', 'Gender_OHS', 'BandGrp_OHS', 'AgeGrp_OHS',
#                                    'TenureGrp_OHS'))
master <- merge(x = master, y = OHS2015, by = c('Year', 'Country', 'Gender_OHS', 'BandGrp_OHS', 'AgeGrp_OHS',
                                                'TenureGrp_OHS'), all.x = TRUE)
     

master <- master[, c("EngageAvg", "EngageAvg_Miss") := NULL]

master[Year == 2009, EngageAvg := Engageavg_2009]
master[Year == 2010, EngageAvg := Engageavg_2010]
master[Year == 2011, EngageAvg := Engageavg_2011]
master[Year == 2012, EngageAvg := Engageavg_2012]
master[Year == 2013, EngageAvg := Engageavg_2013]
master[Year == 2014, EngageAvg := Engageavg_2014]
master[Year == 2015, EngageAvg := Engageavg_2015]

master[, EngageAvg_Miss := as.numeric(is_missing(EngageAvg))]

master[EngageAvg_Miss == 1, EngageAvg := 0]

###CITY DUMMIES

##Create a suite of dummies for the L1+ models based on CITY_CLL

master[, CITY_CLL := "Other"]
master[CITY_CL %in% c("ADANA","ALMATY","AZCAPOTZALCO","BANGALORE","BEIJING","BEOGRAD","BOMBAY","BRADENTON","BUCHAREST",
                      "CAJEME","CHANNO","CHENNAI","CHICAGO","CURITIBA","EKATERINBURG","GREEN PARK","GRODZISK MAZOWIECKI","GUANGZHOU",
                      "GUARULHOS","GURGAON","HYDERABAD","INDIANAPOLIS","ISTANBUL","ITU","IZMIR","IZMIT","KASHIRA","KAZAN","KIEV","KOLKATA",
                      "KRASNODAR","LEBEDYAN","LEICESTER","MERSIN","MEXICALI","MISSISSAUGA","MOSCOW","NEW DELHI","NIKOLAEV","NIZHNY NOVGOROD",
                      "NOVOSIBIRSK","OMSK","PORTO ALEGRE","READING","RIO DE JANEIRO","ROSTOV-ON-DON","SAINT-PETERSBURG","SALTILLO",
                      "SAMARA","SAN NICOLÁS DE LOS GAR","SAN NICOLÁS DE LOS GARZA","SAO PAULO","SHANGHAI","SOMERS","SOROCABA",
                      "TOMASZOW MAZOWIECKI","UFA","VERACRUZ","VOLGOGRAD","WARSAW","WINSTON SALEM","WUHAN","ZAPOPAN",
                      "PARIS", "SHERRIZON"), CITY_CLL:= CITY_CL]

master <- create_dummies2(master, 'CITY_CLL', Threshold = 0)

##Create a suite of dummies for the FL models based on CITY_CLF


master[, CITY_CLF := "Other"]

master[CITY_CL %in% c("ACAPULCO","ADANA","AGUASCALIENTES","AHOME","ALMATY","ALTAMIRA","APARECIDA DE GOIANIA","ARAQUARI",
                        "ATLANTA","AZCAPOTZALCO","AZOV","BAZPUR","BEIJING","BENITO JUÁREZ","BEOGRAD","BHARUCH","BIRCHWOOD",
                        "BISHKEK","BOMBAY","BRADENTON","BRASILIA","BROEK OP LANGEDIJK","BURGOS","BURNSVILLE","CAJEME","CAMPINAS",
                        "CARIACICA","CARREGADO","CEDAR RAPIDS","CELAYA","CENTRO","CHANNO","CHICAGO","CHIHUAHUA","COATZACOALCOS",
                        "CONTAGEM","COVENTRY","CUAUTITLÁN IZCALLI","CUAUTLA","CULIACÁN","CUPAR","CURITIBA","DENVER","DUQUE DE CAXIAS",
                        "DURANGO","ECATEPEC DE MORELOS","EMILIANO ZAPATA","FORT PIERCE","FORTALEZA","GÓMEZ PALACIO","GRODZISK MAZOWIECKI",
                        "GUADALAJARA","GUADALUPE","GUANAJUATO","GUARULHOS","HERMOSILLO","INDIANAPOLIS","IRAPUATO","ISTANBUL",
                        "ITAJAI","ITAPORANGA D AJUDA","ITU","IXTAPALUCA","IZMIR","IZMIT","JABOATAO DOS GUARARAPES","JAINPUR",
                        "JOHNSTOWN","JUÁREZ","KASHIRA","KIEV","KOLKATA","LAS VEGAS","LEBEDYAN","LEICESTER","LEÓN",
                        "LINCOLN","MAHUL","MAMANDUR","MAZATLÁN","MÉRIDA","MERSIN","MESQUITE","MEXICALI","MISSISSAUGA","MORELIA",
                        "MOSCOW","NAUCALPAN DE JUÁREZ","NELAMANGALA","NEW DELHI","NIKOLAEV","NIZHNY NOVGOROD","NOVOSIBIRSK",
                        "OMSK","PACHUCA DE SOTO","PAITHAN","PALAKKAD","PANIPAT","PETERLEE","PORTO ALEGRE","PRAIA GRANDE","PUEBLA",
                        "PUNE","RAMENSKOYE","REYNOSA","RIO DE JANEIRO","ROHA","RUBTSOVSK","SAINT-PETERSBURG","SALTILLO",
                        "SALVADOR","SAN LUIS POTOSÍ","SAN NICOLÁS DE LOS GAR","SAN NICOLÁS DE LOS GARZA","SANGAREDDY",
                        "SANTIAGO DE QUERÉTARO","SAO GONCALO","SAO JOSE DOS CAMPOS","SAO JOSE DOS PINHAIS","SETE LAGOAS",
                        "SHANGHAI","SKELMERSDALE","SOROCABA","TAMPA","TEKIRDAĞ","TIJUANA","TIMASHYOVSK",
                        "TLAJOMULCO DE ZUÑIGA","TOLLESON","TOLUCA","TRES LAGOAS","TUXTLA GUTIÉRREZ","UFA","VERACRUZ",
                        "VEURNE","VITORIA","WARSAW","WUHAN","WYTHEVILLE","ZAPOPAN", "KRASNODAR", "SHERRIZON") , CITY_CLF := CITY_CL]

master <- create_dummies2(master, 'CITY_CLF', Threshold = 0)

##Merge the 2015 FX Rate Dataset with the Master
FXRates2015 <- read_datatable(paste(rawdata_path, "Fx Rates 2015 Local to USD.xlsx", sep = '/') )

FXRates2015[, c("CurrencyCode_NEW", "Year") := NULL]

master <- merge(x = master, y = FXRates2015, by = c('JHCurrencyCode'), all.x = TRUE)

rm(FXRates2015)

master[JHAnnualRate > 1000 & !is_missing(FX), PayAnnRate_USD_2015FX := (JHAnnualRate * FX_2015)]
master[, PayAnnRate_USD_2015FX_Miss := as.numeric(is_missing(PayAnnRate_USD_2015FX))]
master[PayAnnRate_USD_2015FX_Miss == 1, PayAnnRate_USD_2015FX := 0]

master[PayAnnRate_USD_2015FX_Miss != 1, PayAnnRate_USD_2015FX_LN := LN(PayAnnRate_USD_2015FX)]
master[, PayAnnRate_USD_2015FX_LN_Miss = as.numeric(is_missing(PayAnnRate_USD_2015FX_LN))]
master[PayAnnRate_USD_2015FX_LN_Miss == 1, PayAnnRate_USD_2015FX_LN := 0]


##Fix the vars JHLocationCountry & JHLocationCountryDescription for ESSA SC

master[Country == 9, .N, by = JHLocationCountryDescription]
master[Country == 9, .N, by = JHLocationCountry]

master[CITY_CL %in% c('ANAPA', 'ANGARSK', 'ANNA', 'ARKHANGELSK', 'ARMAVIR', 'ASTRAKHAN', 'AZOV', 'BARNAUL', 'BATAISK', 'BATAYSK', 'BELGOROD',
                      'BERDSK', 'BOLSHERECHYE', 'BRYANSK', 'CHEBOKSARY', 'CHELYABINSK', 'CHEREPOVETS', 'DOMODEDOVO', 'EKATERINBURG', 'ESSENTUKI',
                      'GELENDZHIK', "GUL'KEVICHI", 'IRKUTSK', 'ISILKUL', 'IVANOVO', 'IZHEVSK', 'KALININGRAD', 'KALUGA', 'KARASUK', 'KASHIRA', 'KAZAN', 'KEMEROVO',
                      'KHABAROVSK', 'KIROV', 'KRASNODAR', 'KRASNOYARSK', 'KUNGUR', 'KURSK', 'LEBEDYAN', 'LIPETSK', 'MEDVEDOVSKI', 'MEDVEDOVSKOE',
                      'MINERAL WATER', 'MINERALNYE VODY', 'MOSCOW', 'MYTISCHI', 'MYTISHCHI', 'NABEREZHNYE CHELNY', 'NAZAROVO', 'NIZHNY NOVGOROD',
                      'NOVOKUZNETSK', 'NOVOROSSIYSK', 'NOVOSIBIRSK', 'NOVOSIBIRSKWHS', 'OBNINSK', 'OMSK', 'ORENBURG', 'ORSK', 'PENZA', 'PERM',
                      'PERVOURALSK', 'PETROZAVODSK', 'PYATIGORSK', 'RAMENSKOYE', 'REUTOV', 'ROSTOV-ON-DON', 'RUBTSOVSK', 'RYAZAN', 'SAINT-PETERSBURG',
                      'SAMARA', 'SARANSK', 'SARATOV', 'SHERRIZON', 'SMOLENSK', 'SOCHI', 'STAVROPOL', 'SURGUT', "SUZDAL'", 'SYKTYVKAR', 'TAMBOV', 'TIMASHEVSK',
                      'TIMASHYOVSK', 'TOGLYATTI', 'TOLYATTI', 'TOMILINO', 'TOMSK', 'TULA', 'TVER', 'TYUMEN', 'UFA', 'ULAN-UDE', 'ULYANOVSK', 'VELIKY NOVGOROD',
                      'VLADIKAVKAZ', 'VLADIMIR', 'VLADIVOSTOK', 'VOLGOGRAD', 'VOLOGDA', 'VORONEZH', 'YAROSLAVL', 'YESSENTUKI', "YURIEV-POL'SKIY") 
       & is_missing(JHLocationCountry), JHLocationCountry := "RU"]

master[CITY_CL %in% c('ANAPA', 'ANGARSK', 'ANNA', 'ARKHANGELSK', 'ARMAVIR', 'ASTRAKHAN', 'AZOV', 'BARNAUL', 'BATAISK', 'BATAYSK', 'BELGOROD',
                      'BERDSK', 'BOLSHERECHYE', 'BRYANSK', 'CHEBOKSARY', 'CHELYABINSK', 'CHEREPOVETS', 'DOMODEDOVO', 'EKATERINBURG', 'ESSENTUKI',
                      'GELENDZHIK', "GUL'KEVICHI", 'IRKUTSK', 'ISILKUL', 'IVANOVO', 'IZHEVSK', 'KALININGRAD', 'KALUGA', 'KARASUK', 'KASHIRA', 'KAZAN', 'KEMEROVO',
                      'KHABAROVSK', 'KIROV', 'KRASNODAR', 'KRASNOYARSK', 'KUNGUR', 'KURSK', 'LEBEDYAN', 'LIPETSK', 'MEDVEDOVSKI', 'MEDVEDOVSKOE',
                      'MINERAL WATER', 'MINERALNYE VODY', 'MOSCOW', 'MYTISCHI', 'MYTISHCHI', 'NABEREZHNYE CHELNY', 'NAZAROVO', 'NIZHNY NOVGOROD',
                      'NOVOKUZNETSK', 'NOVOROSSIYSK', 'NOVOSIBIRSK', 'NOVOSIBIRSKWHS', 'OBNINSK', 'OMSK', 'ORENBURG', 'ORSK', 'PENZA', 'PERM',
                      'PERVOURALSK', 'PETROZAVODSK', 'PYATIGORSK', 'RAMENSKOYE', 'REUTOV', 'ROSTOV-ON-DON', 'RUBTSOVSK', 'RYAZAN', 'SAINT-PETERSBURG',
                      'SAMARA', 'SARANSK', 'SARATOV', 'SHERRIZON', 'SMOLENSK', 'SOCHI', 'STAVROPOL', 'SURGUT', "SUZDAL'", 'SYKTYVKAR', 'TAMBOV', 'TIMASHEVSK',
                      'TIMASHYOVSK', 'TOGLYATTI', 'TOLYATTI', 'TOMILINO', 'TOMSK', 'TULA', 'TVER', 'TYUMEN', 'UFA', 'ULAN-UDE', 'ULYANOVSK', 'VELIKY NOVGOROD',
                      'VLADIKAVKAZ', 'VLADIMIR', 'VLADIVOSTOK', 'VOLGOGRAD', 'VOLOGDA', 'VORONEZH', 'YAROSLAVL', 'YESSENTUKI', "YURIEV-POL'SKIY") 
       & is_missing(JHLocationCountryDescription), JHLocationCountryDescription := "Russian Federation"]

master[CITY_CL %in% c('ADANA', 'ANKARA', 'ANTALYA', 'BEREZNIKI', 'BURSA', 'ISTANBUL', 'IZMIR', 'IZMIT', 'MERSIN', 'MUĞLA', 'NIĞDE', 'TEKIRDAĞ', 'TOKAT') 
       & is_missing(JHLocationCountry), JHLocationCountry := "TR"]

master[CITY_CL %in% c('ADANA', 'ANKARA', 'ANTALYA', 'BEREZNIKI', 'BURSA', 'ISTANBUL', 'IZMIR', 'IZMIT', 'MERSIN', 'MUĞLA', 'NIĞDE', 'TEKIRDAĞ', 'TOKAT') 
       & is_missing(JHLocationCountryDescription), JHLocationCountryDescription := "Turkey"]

master[is_missing(CITY_CL) & is_missing(JHLocationCountry) & Country == 9 & JHCurrencyCode == "TL", JHLocationCountry :=  "TR"]
master[is_missing(CITY_CL) & is_missing(JHLocationCountryDescription) & Country == 9 & JHCurrencyCode == "TL", JHLocationCountryDescription := "Turkey"]

master[Country == 9 & JHLocationCountryDescription == "Uzbekistan" & is_missing(JHLocationCountry), JHLocationCountry := "UZ"]

########################

save(master, file = paste(data_path, "Master SWP Dataset 4 30 2016 v16.RData", sep= '/'))

########################

### Delete from Russia outside BU.
ToExcludeRussia <- read_datatable(paste(rawdata_path, "To be excluded from Russia data file.xlsx", sep = '/') )

ToExcludeRussia[, GPID:=sprintf("%08d", GPID)]

ToExcludeGPIDs <- ToExcludeRussia$GPID
rm(ToExcludeRussia)

##Flag as out of study the employees in the list with Country == 6
master[(GPID %in% ToExcludeGPIDs) & (Country == 6), InStudy_All := 0]
master[(GPID %in% ToExcludeGPIDs) & (Country == 6), InStudy_AllPay := 0]
master[(GPID %in% ToExcludeGPIDs) & (Country == 6), InStudy_Russia := 0]
master[(GPID %in% ToExcludeGPIDs) & (Country == 6), InStudy_RussiaPay := 0]

master[, out_BU := 0]
master[(GPID %in% ToExcludeGPIDs) & (Country == 6), out_BU := 1]

###Delete from UK outside UKBU.
master[(JHOrgLvlShort4Description %in% c("UK/Ireland - Ireland", "UK/Ireland - New Ventures",
            "UK/Ireland - Trop/Quaker","WESA - UK BU")) & (Country == 8), InStudy_All := 0]
master[(JHOrgLvlShort4Description %in% c("UK/Ireland - Ireland", "UK/Ireland - New Ventures",
            "UK/Ireland - Trop/Quaker","WESA - UK BU")) & (Country == 8), InStudy_AllPay := 0]
master[(JHOrgLvlShort4Description %in% c("UK/Ireland - Ireland", "UK/Ireland - New Ventures",
            "UK/Ireland - Trop/Quaker","WESA - UK BU")) & (Country == 8), InStudy_Russia := 0]
master[(JHOrgLvlShort4Description %in% c("UK/Ireland - Ireland", "UK/Ireland - New Ventures",
            "UK/Ireland - Trop/Quaker","WESA - UK BU")) & (Country == 8), InStudy_RussiaPay := 0]
master[(JHOrgLvlShort4Description %in% c("UK/Ireland - Ireland", "UK/Ireland - New Ventures",
            "UK/Ireland - Trop/Quaker","WESA - UK BU")) & (Country == 8), out_BU := 1]

###Add CS&L Column for employees in ESSA SC.
CSL <- read_datatable(paste(rawdata_path, "cs&l_split.xlsx", sep = '/') )

CSL[nchar(Emplid) < 8, Emplid:=str_pad(Emplid, width=8, side="left", pad="0")]

CSL <- remove_dups(CSL, c("Emplid", "Year"))


CSL <- merge(x = CSL, y = master[Country == 9 & Russia_Dups == 1, ], by = c("Emplid", "Year"), all.x = TRUE)
CSL <- CSL[is_missing(EMPLOYEENAME),]

master <- add_new_dataset(new_dt = CSL, Country_num = 11, diffvars_meth = 2, old_dt = master)
rm(CSL)


##Value Labels Country 1 'China' 2 'India' 3 'Mexico' 4 'Brazil' 5 'Turkey' 6 'Russia' 7 'NAB SC' 8 'UK' 9 'ESSA SC' 10 'Ukraine & CIS' 11 'ESSA SC CSL'.

master[, Country_China:= as.numeric((Country == 1))]
master[, Country_India:= as.numeric((Country == 2))]
master[, Country_Mexico:= as.numeric((Country == 3))]
master[, Country_Brazil:= as.numeric((Country == 4))]
master[, Country_Turkey:= as.numeric((Country == 5))]
master[, Country_Russia:= as.numeric((Country == 6))]
master[, Country_NAB_SC:= as.numeric((Country == 7))]
master[, Country_UK:= as.numeric((Country == 8))]
master[, Country_ESSA_SC:= as.numeric((Country == 9))]
master[, Country_Ukraine_CIS:= as.numeric((Country == 10))]
master[, Country_ESSA_CSL:= as.numeric((Country == 11))]

master[Country == 11, CITY_CLL_Other := 0]
master[Country == 11, CITY_CLF_Other := 0]

master[Country == 11 & !CITY_CLL%in% c("SAINT-PETERSBURG", "LEICESTER", "LEBEDYAN", "KASHIRA", "MOSCOW", 
                          "NOVOSIBIRSK", "EKATERINBURG", "PARIS", "SHERRIZON"), CITY_CLL_Other := 1]
master[Country == 11 & !CITY_CLL%in% c("MOSCOW", "LEICESTER", "SAINT-PETERSBURG", "LEBEDYAN",  "KIEV" , 
                                       "SHERRIZON", "NOVOSIBIRSK", "BIRCHWOOD", "KRASNODAR", "UFA", 
                                       "NIZHNY NOVGOROD"), CITY_CLF_Other := 1]



### Change ReHire Status from some employees in Russia: Not real Rehires that were flagged as Rehires in the system.
NoRH <- read_datatable(paste(rawdata_path, "list_ru_norehires.xlsx", sep = '/') )

NoRH[, norh := 1]

# NoRH[, GPID:=sprintf("%08d", Emplid)]
# 
# NoRH <- remove_dups(NoRH, c("GPID", "Year"))
# 
# master <- merge(x = master, y = NoRH, by = c("GPID", "Year"), all.x = TRUE)

NoRH[, Emplid:=sprintf("%08d", Emplid)]

NoRH <- remove_dups(NoRH, c("Emplid", "Year"))

master <- merge(x = master, y = NoRH, by = c("Emplid", "Year"), all.x = TRUE)

rm(NoRH)

master[is_missing(norh), norh := 0]
master[norh == 1, ReHire := 0]



### CS&L critical roles
master[Country %in% c(9, 11), CriticalJob := 0]
master[Country %in% c(9, 11) & GPID %in% c('20612616','40220795','40259603','40004042','40137140',
                                           '20607694','20304192','40140270'), CriticalJob := 1]

##Add Critical Roles for UK 

master <- add_CR(master, paste(rawdata_path, "uk_cr.xlsx", sep = '/'), 8, rm_current_CR = TRUE)

###

WFO_dataset <- read_datatable(paste(rawdata_path, 'WFO 2010-2015 L8+ dataset structured.sav', sep = '/') )
WFO_dataset <- WFO_dataset[, .(Emplid, Year, Term_Vol, HighPotential_CurYr)]

WFO_dataset <- rename(WFO_dataset, c("Term_Vol"="Turn_Vol_WFO", "HighPotential_CurYr"="TC_HP_WFO"))

# WFO_dataset[, GPID:=sprintf("%08d", Emplid)]
# master <- merge(x = master, y = WFO_dataset, by = c("GPID", "Year"), all.x = TRUE)

WFO_dataset[, Emplid:=sprintf("%08d", Emplid)]

master <- merge(x = master, y = WFO_dataset, by = c("Emplid", "Year"), all.x = TRUE)
rm(WFO_dataset)


#############
save(master, file = paste(data_path, "Master SWP Dataset 4 30 2016 v23.RData", sep= '/'))

View(master)
export(master, "master.csv")

write.csv(master, file = "C:/Personal/71032003/SWP R Syntax/Data/Master.csv", row.names = FALSE)






