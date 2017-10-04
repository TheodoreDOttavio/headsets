class ScansController < ApplicationController
  def index
    administratorsOnly
  end

  def sort
    administratorsOnly

    require 'fileutils'

    @lastperformanceid = 1
    @lastweek = (weekstart - 14).strftime('%Y-%m-%d')
    @lastformat = 1

    # From a post, so move the file, and set the selections to save time
    #  is the post a newly uploaded file vs going through the assets/images//ftp directory
    if params[:Data]
      @thisfilename = params[:Data].original_filename
      @thisimage = params[:Data].tempfile
    else
      if params[:placeperformance]
        myfile = 'app/assets/images/' + params[:placefile].to_s
        myplacedfile = params[:placeperformance].to_s + '-' +
                       params[:placeweek].to_s + '-' +
                       params[:paperworkformat].to_s + '.jpg'
        myplacedpath = 'app/assets/images/' +
                       params[:placeweek].to_s.split('-').first + '/' +
                       params[:placeperformance].to_s + '/'
        # @testertext = myfile + " moved to " + myplacedpath + myplacedfile

        # Create folders if needed and move the file
        FileUtils.mkdir_p myplacedpath
        if !Dir.glob(myplacedpath + myplacedfile).empty?
          flash[:error] = 'Scanned File exists!'
          # redirect_to scans_path
        else
          FileUtils.mv myfile, myplacedpath + myplacedfile

          # record the new scan in the Scans db
          ss = false
          ss = true if params[:paperworkformat].to_i == 2

          mondayarray = params[:placeweek].split('-')
          monday = DateTime.new(mondayarray[0].to_i, mondayarray[1].to_i, mondayarray[2].to_i)
          obj = Scan.new(performance_id: params[:placeperformance],
            monday: monday, specialservices: ss)
          obj.save
        end

        # pass along the pull down variables for speedy entering...
        @lastperformanceid = params[:placeperformance]
        @lastweek = params[:placeweek]
        @lastformat = params[:paperworkformat]
      end
      # find the next image to sort:
      jpegfilelist = Dir.glob('app/assets/images/ftp/*.jpg')
      @remaining = jpegfilelist.length
      @thisimage = 'ftp/' + jpegfilelist.first.split('/').last if jpegfilelist != []
      redirect_to scans_path if jpegfilelist == []
    end

    # Performances
    @performances = Performance.nowshowing.select(:name, :id).order(:name)
    # @performances = Performance.select(:name, :id).order(:name)

    # Type of paperwork being uploaded
    @paperformat = []
    @paperformat.push(['Infrared Daily Log', 1])
    @paperformat.push(['Special Services Log', 2])

    # Show a list of weeks going back 3 years:
    @completeweeks = Distributed.completeweeks(weekstart)

  end
end
