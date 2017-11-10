class DistributedsController < ApplicationController
  def index
    administratorsOnly

    @mystart = if params[:mystart]
      params[:mystart].to_date
    else
      weekstart
    end

    @weekof = @mystart.strftime('%b %d') + ' to ' + (@mystart + 6).strftime('%b %d, %Y')

    @showstoedit = []
    performances = Performance.showinglist(@mystart)
    performances.each do |p|
      mycount = Distributed.datespan(@mystart, (@mystart+7)).where('performance_id = ?', p.id).count
      if mycount != 0 then
        @showstoedit.push([p.name[0..16],p.id,"btn btn-sm btn-primary"])
      else
        @showstoedit.push([p.name[0..16],p.id,"btn btn-sm btn-danger"])
      end
    end

    #Display where the data is at - overview of what has been entered
    @weektoedit = Array.new
    @weekstartstoedit = []

    if params[:myweekslist]
     weekslist = params[:myweekslist].to_i
    else
     weekslist = 8
    end

    for i in 1..weekslist do
      mystart = weekstart - (i * 7)

      #add in some info about what has been entered
      myshowcount = Performance.showingcount(mystart, (mystart+6))
      myinfraredcount = Distributed.infraredwkcount(mystart)
      # myscanscount = Scan.scanscount(mystart)
      # myssscanscount = Scan.ssscanscount(mystart)

      if myinfraredcount == 0 then #&& myspecialservicescount == 0 then
        mybuttonclass = "btn btn-sm btn-danger"
      else
        if myinfraredcount < myshowcount then
          mybuttonclass = "btn btn-sm btn-warning"
        else
          mybuttonclass = "btn btn-sm btn-primary"
        end
      end

      @weektoedit.push({"showweekof" => mystart.strftime('%b %d')+" to "+ (mystart+7).strftime('%b %d, %Y'),
        "startdate" => mystart,
        "infraredcount" => myinfraredcount,
        "buttonclass" => mybuttonclass})
    end
  end


  def show
  end


  def new
    @mystart = if params[:mystart]
      params[:mystart].to_date
    else
      weekstart
    end

    @weekof = @mystart.strftime('%b %d')+" to "+ (@mystart+6).strftime('%b %d, %Y')

    #Get the Show
    @performance = Performance.find(params[:performance_id])

    #Build a week of Distributeds - 14 shifts
    @weekofdistributed = []
    existingdist = Distributed.datespan(@mystart, @mystart+7).where(performance_id: params[:performance_id], product_id: [6..7])
    thiseve = false
    thisdate = @mystart

    (0..13).each do |i|
      existingdist.each do |e|
        if thisdate == e.curtain && thiseve == e.eve then
          @weekofdistributed.push(e)
        end
      end
      emptydist = Distributed.new(performance_id: params[:performance_id],
        curtain: thisdate,
        eve: thiseve,
        product_id: 6,
        language: 0,
        isinfrared: true,
        id: 0)

      @weekofdistributed.push(emptydist) if @weekofdistributed.count == i

      if thiseve == false then
        thiseve = true
      else
        thiseve = false
        thisdate = thisdate + 1.day
      end
    end

    # weekofdistributed[i] = Distributed.new(performance_id: performanceid,
    #    curtain: thisdate,
    #    eve: thiseve,
    #    product_id: productid,
    #    language: thislang,
    #    representative: distributedsearch.first.representative,
    #    id: distributedsearch.first.id,
    #    quantity: distributedsearch.first.quantity)
  end


  def create
  end


  def edit
  end


  def update
  end


  def destroy
  end
end
