// !preview r2d3 data=readr::read_tsv("model_scripts/r2d3/data.tsv"), d3_version = "3", container = "div"
//
// r2d3: https://rstudio.github.io/r2d3
//
// <script src="https://d3js.org/d3-selection-multi.v1.min.js"></script>




// set the dimensions and margins of the graph
var margin = {top: 30, right: 30, bottom: 70, left: 60},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
var svg = //d3.select("#my_dataviz")
  div.append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

// Initialize the X axis
//var x = d3.scaleBand()
  //.range([ 0, width ])
  //.padding(0.2);
var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .2);

var xAxis = svg.append("g")
  .attr("transform", "translate(0," + height + ")");

// Initialize the Y axis
//var y = d3.scaleLinear()
  //.range([ height, 0]);
var y = d3.scale.linear()
    .range([height, 0]);
    
var yAxis = svg.append("g")
  .attr("class", "myYaxis");


// A function that create / update the plot for a given variable:
function update(data) {

  // Update the X axis
  x.domain(data.map(function(d) { return d.group; }))
  //xAxis.call(d3.axisBottom(x))
  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  // Update the Y axis
  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")

  y.domain([0, d3.max(data, function(d) { return d.value }) ]);
  //yAxis.transition().duration(1000).call(d3.axisLeft(y));



  // Create the u variable
  var u = svg.selectAll("rect")
    .data(data)

  u
    .enter()
    .append("rect") // Add a new rect for each new elements
    .merge(u) // get the already existing elements as well
    .transition() // and apply changes to all of them
    .duration(1000)
      .attr("x", function(d) { return x(d.group); })
      .attr("y", function(d) { return y(d.value); })
      .attr("width", x.bandwidth())
      .attr("height", function(d) { return height - y(d.value); })
      .attr("fill", "#69b3a2")

  // If less group in the new dataset, I delete the ones not in use anymore
  u
    .exit()
    .remove()
}

// Initialize the plot with the first dataset
update(data) //update(data1)