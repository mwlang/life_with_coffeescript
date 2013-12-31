$ ->
  $worldSize = null
  $worldRange = null
  $cells = null
  
  $("#world_form").submit (el) ->
    el.preventDefault()
    resize_world()
    
  $("#world_size").change (el) -> 
    resize_world(el)

  delayFactor = -> 
    return 300 if $worldSize < 25
    return 200 if $worldSize < 75
    return 100 if $worldSize < 100
    return 1
    
  evolve_world = ->
    birthing_cells = []
    dying_cells = []

    for y in $worldRange
      for x in $worldRange
        victim = $cells[x][y]
        alive = victim.hasClass('alive')
        neighbors = count_neighbors(x, y)

        dying_cells.push victim if (neighbors < 2) || (neighbors > 3) && alive
        birthing_cells.push victim if (neighbors == 2) || (neighbors == 3) && !alive

    victim.removeClass('alive') for victim in dying_cells
    victim.addClass('alive') for victim in birthing_cells

    setTimeout(evolve_world, delayFactor())

  resize_world = (el) ->
    el.preventDefault() if el

    $worldSize = $("#world_size").val()
    if $worldSize == ''
      $("#world_size").val("25")
      $worldSize = 25

    $worldRange = [0..$worldSize - 1]
    $cells = $worldRange.map -> $worldRange.map -> null
    
    $("#world tr").remove()
    
    for y in $worldRange
      $("#world").append(newRow = $("<tr></tr>"))
      for x in $worldRange
        newRow.append($cells[x][y] = $("<td></td>"))
        $cells[x][y].addClass('alive') if Math.random() < 0.05

    evolve_world()
    
  count_neighbors = (x, y) =>
    top    = Math.max(y - 1, 0)
    left   = Math.max(x - 1, 0)
    bottom = Math.min(y + 1, $worldSize - 1)
    right  = Math.min(x + 1, $worldSize - 1)
    
    neighbors = 0
    for row in [top..bottom]
      for column in [left..right]
        neighbors++ if [row, column] != [x, y] && $cells[column][row].hasClass('alive')
          
    neighbors
    
  resize_world()
