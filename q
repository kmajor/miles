
[1mFrom:[0m /home/ubuntu/workspace/app/controllers/searches_controller.rb @ line 32 SearchesController#create:

    [1;34m26[0m:   [32mdef[0m [1;34mcreate[0m
    [1;34m27[0m: 
    [1;34m28[0m:     search_attributes = search_params
    [1;34m29[0m:     search_attributes[[33m:origin[0m] = [1;34;4mAirport[0m.where([35miata[0m: search_params[[33m:origin[0m].upcase) [32munless[0m search_params[[33m:origin[0m].numeric?
    [1;34m30[0m:     search_attributes[[33m:destination[0m] = [1;34;4mAirport[0m.where([35miata[0m: search_params[[33m:destination[0m].upcase) [32munless[0m search_params[[33m:destination[0m].numeric?
    [1;34m31[0m: 
 => [1;34m32[0m: binding.pry
    [1;34m33[0m: 
    [1;34m34[0m:     @search = [1;34;4mSearch[0m.new(search_attributes)
    [1;34m35[0m: 
    [1;34m36[0m:     respond_to [32mdo[0m |format|
    [1;34m37[0m:       [32mif[0m @search.save
    [1;34m38[0m:         format.html { redirect_to @search, [35mnotice[0m: [31m[1;31m'[0m[31mSearch was successfully created.[1;31m'[0m[31m[0m }
    [1;34m39[0m:         format.json { render [33m:show[0m, [35mstatus[0m: [33m:created[0m, [35mlocation[0m: @search }
    [1;34m40[0m:       [32melse[0m
    [1;34m41[0m:         format.html { render [33m:new[0m }
    [1;34m42[0m:         format.json { render [35mjson[0m: @search.errors, [35mstatus[0m: [33m:unprocessable_entity[0m }
    [1;34m43[0m:       [32mend[0m
    [1;34m44[0m:     [32mend[0m
    [1;34m45[0m:   [32mend[0m

