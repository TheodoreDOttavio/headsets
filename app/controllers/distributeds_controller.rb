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
    @weekofdistributed = {}
    existingdist = Distributed.datespan(@mystart, @mystart+7).where(performance_id: params[:performance_id], product_id: [6..7])
    thiseve = false
    thisdate = @mystart

    (0..13).each do |shift|
      label = thisdate.strftime('%a')
      thiseve ? label += " Eve  " : label += " Mat  "
      label += thisdate.strftime('%-m-%-d')

      @weekofdistributed["label_#{shift}"] = label
      @weekofdistributed["data_#{shift}"] = []
      (6..7).each do |product|
        foundone = false
        existingdist.each do |e|
          if thisdate == e.curtain && thiseve == e.eve && product == e.product_id then
            @weekofdistributed["data_#{shift}"].push(e)
            foundone = true
          end
        end
        if foundone == false then
          emptydist = Distributed.new(performance_id: params[:performance_id],
            curtain: thisdate,
            eve: thiseve,
            product_id: product,
            language: 0,
            isinfrared: true,
            id: 0)
          @weekofdistributed["data_#{shift}"].push(emptydist)
        end
      end

      if thiseve == false then
        thiseve = true
      else
        thiseve = false
        thisdate = thisdate + 1.day
      end
    end

    @languages = Shortlists.new.languages
    @languages.delete(:Infrared)
    @weekofssdistributed = {}
    existingdist = Distributed.datespan(@mystart, @mystart+7).where(performance_id: params[:performance_id], product_id: [4..5])
    thiseve = false
    thisdate = @mystart

    (0..13).each do |shift|
      label = thisdate.strftime('%a')
      thiseve ? label += " Eve  " : label += " Mat  "
      label += thisdate.strftime('%-m-%-d')

      @weekofssdistributed["label_#{shift}"] = label
      @weekofssdistributed["data_#{shift}"] = []
      @languages.each do |key, language|
        product = 4
        product = 5 if language == 1
        foundone = false
        existingdist.each do |e|
          if thisdate == e.curtain && thiseve == e.eve && language == e.language then
            @weekofssdistributed["data_#{shift}"].push(e)
            foundone = true
          end
        end
        if foundone == false then
          emptydist = Distributed.new(performance_id: params[:performance_id],
            curtain: thisdate,
            eve: thiseve,
            product_id: product,
            language: language,
            isinfrared: false,
            id: 0)
          @weekofssdistributed["data_#{shift}"].push(emptydist)
        end
      end

      if thiseve == false then
        thiseve = true
      else
        thiseve = false
        thisdate = thisdate + 1.day
      end

    end

  end


  def create
    puts " _____________"
    puts params
    puts " _____________"
    redirect_to distributeds_path

    # {"utf8"=>"✓", "authenticity_token"=>"VhcUH8LXHZzjcDyo0j64feRDlUqIyeXpO86OJZ06Obbm7SThO31K6/mltVC2h2mwuqyUJ1hJO03f0+itAnLdpg==", "commit"=>"Save", "distributed"=>{"id"=>"0", "curtain"=>"2017-03-12 00:00:00 UTC", "eve"=>"true", "performance_id"=>"75", "product_id"=>"4", "language"=>"8", "quantity"=>""}, "id"=>"1", "method"=>"post", "mystart"=>"2017-03-06T00:00:00+00:00", "controller"=>"distributeds", "action"=>"create"}

  end


  def edit
  end


  def update
  end


  def destroy
  end
end
