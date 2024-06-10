=begin
Last names: San Buenaventura, Donaire, Co Chiong
Languages: Kotlin, Go, Ruby
Paradigms: Object Oriented Programing, Function Programing, Procedural, Functional Imperative
=end
require 'date'


class Day
    #intilization of basic Day Interval
    

    def initialize(days)
        @dayofweek = days #initalization of each day (Sunday,Monday,Tuesday...)
        @daytype = (6 == days || 0 == days) ? "Rest Day" : "Normal Day" #check if saturday or sun then initalize to 9
        @intime = 9
        @outtime = 9
        @ot_rate = 1
        @shift = "Day"
        @daily_rate = 1
    end
    def checkovertime
        return ((outtime-intime) >= 0) ? (outtime-intime)-8 : 0
    end
    # Class Setters for Day
    def change_intime(intime)
        @intime = intime
    end

    def change_day_type (dt)
        @daytype = dt
    end

    def change_shift (st)
        @shift = st
    end

    def change_otrate (ot_rate)
        @ot_rate = ot_rate
    end

    def change_outtime(ot)
        @outtime = ot
    end
    # Class Getters for Day

    def dayofweek
        @dayofweek
    end

    def daytype
        @daytype
    end

    def intime
        @intime
    end

    def outtime
        @outtime
    end

    def ot_rate
        @ot_rate
    end

    def shift
        @shift
    end
    
    def daily_rate
        @daily_rate
    end
    
    # Format to display weekdays
    def display_weekdays
        return Date::DAYNAMES[@dayofweek]
    end

    
    
end

def setupday

    puts "--Weekly Computation--"

    $daysofweek.times do |days|
        #configure sunday as last day
        days = -1 if days == 6

        #setting up  new days
        $Dayclasses << Day.new(days+1)
    end
    
end

def checkovertime (out_time, in_time)
    check = ((out_time - in_time) > 0) ? ((out_time - in_time) - 8) : 0
end

def checktwodays (out_time,in_time)
    newouttime = out_time
    newouttime = 24 + out_time if out_time < in_time
    return newouttime
end

def change_td (options) #Menu for changing Type of day
    puts "--Types of Day--"
                puts "1. Normal Day"
                puts "2. Rest Day"
                puts "3. Special Non Working Holiday (SNWH)"
                puts "4. SNWH and Rest Day" 
                puts "5. Holiday"
                puts "6. Holiday and Rest Day"
                print"Enter Choice: "

                tod = gets.chomp.to_i #input detector

                case tod #switch statement depending on user choice
                when 1 
                      $Dayclasses[options-1].change_day_type("Normal Day")    #change daytype value to desired value
                when 2 
                      $Dayclasses[options-1].change_day_type("Rest Day")
                when 3 
                      $Dayclasses[options-1].change_day_type("SNWH")
                when 4 
                      $Dayclasses[options-1].change_day_type("SNWH-Rest Day")
                when 5 
                      $Dayclasses[options-1].change_day_type("Holiday")
                when 6 
                      $Dayclasses[options-1].change_day_type("H-Rest Day")
                end
end

module Time_f

    def format_time(time)
        #formating for time
        time = 0 if time == 24
        string_time = time.to_s << "00"
        string_time = "0" << string_time if time < 10
        return string_time
    end

    def check_time(time)
        return 0 <= time && time <= 24  
    end
end

def configure_weeklypayroll #configure payroll
    include Time_f 
        @options = 0 #local declaration of variable

        loop do
            puts "-- Configure Payroll --".center(18)
            print "Enter a Day of a week (1 = monday, 7 = sunday, etc.): "
            @options = gets.chomp.to_i #prompt user with a choice of date
        break if ((1...7) === @options)
        end
        #display Day Details
        puts "-Day #{@options} Details-"
        puts "\t1. Type of Day:     " + $Dayclasses[@options-1].daytype
        puts "\t2. INTIME:          " + $get_time.call($Dayclasses[@options-1].intime)
        puts "\t3. OUTTIME:         " + $get_time.call($Dayclasses[@options-1].outtime)
        puts "\t4. Shift:           " + $Dayclasses[@options-1].shift
        print "Which would you Like to configure: "
        option = gets.chomp.to_i

        #switch statment for choice to configure
        case option
            when 1
                change_td(@options)
            when 2
                print"\nEnter INTIME (0:24): "
                tod = gets.chomp.to_i
                    $Dayclasses[@options-1].change_intime(tod) #change intime
            when 3
                print"\nEnter OUTIME (0:24): "
                tod = gets.chomp.to_i
                    $Dayclasses[@options-1].change_outtime(tod) #change outtime
            when 4 
                puts $Dayclasses[@options-1].shift
              if($Dayclasses[@options-1].shift == "Night")      
                    $Dayclasses[@options-1].change_shift("Day") #change shift
                    
              elsif ($Dayclasses[@options-1].shift == "Day")      
                    $Dayclasses[@options-1].change_shift("Night")
                    
              end
              puts "Shift Changed to " + $Dayclasses[@options-1].shift
            else
                raise 'Wrong Input of Configuration' # raise an error
        end

        print "Enter y to go Back to Menu: "
        back = gets.chomp
        back.downcase!
        if (back == "y") 
            main_menu 
        end
end
    


def calculate_daily(day,newouttime,overtime,orate)
    
    return[0,0,0] if (newouttime - day.intime) == 0 # Returns 0 for all if not worked that day

    norm_salary = 500/((newouttime - day.intime) - overtime) * $Rate[getkey(day.daytype)] # reg work salary
    over_salary = overtime * ($reg_salary/8)  * orate #overtime salary
    daily = over_salary + norm_salary #compute Daily
    return [daily,over_salary,norm_salary]

end

def display_daily(day) #display day details
    include Time_f
    dayw = 7
    dayw = day.dayofweek unless day.dayofweek == 0#change to Present Day of 7 as Sunday

    puts "--DAY #{dayw}--"
    puts "- Week of the Day: " + day.display_weekdays
    puts "- Regular Salary Rate: #{$reg_salary}"
    puts "- IN TIME: #{$get_time.call(day.intime)}"
    puts "- OUT TIME: #{$get_time.call(day.outtime)}"
    puts "- Day Type: #{day.daytype}"
    puts "- Day Shift: #{day.shift}"
    newouttime = (checktwodays(day.outtime,day.intime))
    overtime = checkovertime(newouttime , day.intime)
    puts "- Overtime: " + overtime.to_s

    if day.shift=="Day"
        orate = $Reg_Overtime_Rate[getkey(day.daytype)]

    elsif day.shift=="Night"
        orate= $Night_Overtime_Rate[getkey(day.daytype)]
    end
    daily,over_salary,norm_salary = calculate_daily(day,newouttime,overtime,orate)

    if (day.daytype != "Normal Day")
        puts "Daily Salary: #{norm_salary} " + "Work Hrs: " + $get_time.call(day.intime) + "-" + $get_time.call(day.outtime)
    end
    if(overtime > 0)
        puts "Overtime salary: Hours OT x OT hours"
        puts " #{overtime} * #{$reg_salary} / 8 * #{orate}"
        puts " - Overtime Salary: " + over_salary.to_s
        print "Overtime Salary + "
    end
    puts "Normal Salary: " + daily.to_s
end

def getkey (type) #get hash key from day type
    case type 
    when "Normal Day"
        return :Normal_day
    when "Rest Day"
        return :Rest_day
    when "SNWH"
        return :NON_workday
    when "SNWH-Rest Day"
        return :RestandNON
    when "Holiday"
        return :Holiday
    when "H-Rest Day"
        return :RestandHol
    end
end

def display_week #display each day per week
    $Dayclasses.each do |day|
        display_daily(day)
        print "\n"
    end
    
    print "Enter y to go Back to Menu: "
        back = gets.chomp
        back.downcase!
        if (back == "y") 
            main_menu 
        end
end

#global declarations to be used throught the program
    $reg_salary = 500
    $daysofweek = 7
    $Dayclasses = Array.new
    $work_hrs = 8
    $get_time = lambda {|time| check_time(time)? format_time(time) : "9999"}

    $Rate = {
        #special hourly rates for special days
        Normal_day:1,
        Rest_day: 1.30,
        NON_workday: 1.30,
        RestandNON: 1.50,
        Holiday:  2.00,
        RestandHol: 2.60  
    }

    $Night_Overtime_Rate = {
        #overtime rates for night shift
        Normal_day: 1.375,
        Rest_day: 1.859,
        NON_workday: 1.859,
        RestandNON: 2.145,
        Holiday:  2.86,
        RestandHol: 3.718
    }

    $Reg_Overtime_Rate = {
        # overtime rates for day shift
        Normal_day: 1.25,
        Rest_day: 1.69,
        NON_workday: 1.69,
        RestandNON: 1.95,
        Holiday:  2.60,
        RestandHol: 3.38
    }

def main_menu
    #main menu
    puts "--------------------"
    puts "== PAYROLL SYSTEM ==".center(18)
    puts "--------------------"
    puts "\nSelect an Option: "
    puts "\t 1 - Configure Week Payroll"
    puts "\t 2 - Calculate Weekly Payroll"
    puts "\t 3 - Terminate Program"
    print "\nOption: "

    options = gets.chomp.to_i
    system('cls')
    case options
        when 1 
            configure_weeklypayroll #configure payroll
        when 2
            display_week
        when 3
            return
        else
            main_menu
        end
end

setupday #function to initalize days
main_menu
exit