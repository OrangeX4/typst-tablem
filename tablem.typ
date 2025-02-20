// convert a sequence to a array splited by "|"
#let _tablem-tokenize(seq) = {
  let res = ()
  for cont in seq.children {
    if cont.func() == text {
      res = res + cont.text.split("|").map(s => text(s.trim())).intersperse([|]).filter(it => it.text != "")
    } else {
      res.push(cont)
    }
  }
  res
}

// trim first or last empty space content from array
#let _arr-trim(arr) = {
  if arr.len() >= 2 {
    if arr.first() in ([], [ ], parbreak(), linebreak()) {
      arr = arr.slice(1)
    }
    if arr.last()  in ([], [ ], parbreak(), linebreak()) {
      arr = arr.slice(0, -1)
    }
    arr
  } else {
    arr
  }
}

// compose table cells
#let _tablem-compose(arr) = {
  let res = ()
  let column-num = 0
  res = arr.split([|]).map(_arr-trim).map(subarr => subarr.sum(default: []))
  _arr-trim(res)
}

// merge cells in a row
#let _merge-cells(row, start, count) = {
  let merged = ()
  let i = 0
  while i < count {
    if i >= row.len() { break }
    if row.at(i) == [>] {
      let span = 1
      let j = i + 1
      while j < count and j < row.len() and row.at(j) == [>] {
        span += 1
        j += 1
      }
      if j < count and j < row.len() {
        merged.push(table.cell(colspan: span + 1, row.at(j)))
        i = j + 1
      } else {
        i = j
      }
    } else {
      merged.push(row.at(i))
      i += 1
    }
  }
  merged
}

#let _process-table-body(body, columns) = {
  let processed = ()
  let row = ()
  for (i, cell) in body.enumerate() {
    row.push(cell)
    if calc.rem(i + 1, columns) == 0 {
      processed += _merge-cells(row, 0, columns)
      row = ()
    }
  }
  processed
}

#let tablem(
  render: table,
  ignore-second-row: true,
  use-table-header: true,
  ..args,
  body,
) = {
  let arr = _tablem-compose(_tablem-tokenize(body))
  // use the count of first row as columns
  let columns = 0
  for item in arr {
    if item == [ ] {
      break
    }
    columns += 1
  }
  // split rows with [ ]
  let res = ()
  let count = 0
  for item in arr {
    if count < columns {
      res.push(item)
      count += 1
    } else {
      assert.eq(
        item,
        [ ],
        message: "There should be a linebreak. Or, instead of using empty cells in table header, just use the empty string `| #\" \" |`  in table header instead.",
      )
      count = 0
    }
  }
  let len = res.len()
  let table-header = res.slice(0, calc.min(columns, len))
  let table-body = if ignore-second-row {
    // remove secound row
    res.slice(calc.min(2 * columns, len))
  } else {
    res.slice(calc.min(columns, len))
  }
  let processed-body = _process-table-body(table-body, columns)
  // render with custom render function
  if use-table-header {
    render(columns: columns, ..args, table.header(..table-header), ..processed-body)
  } else {
    render(columns: columns, ..args, ..table-header, ..processed-body)
  }
}

#let three-line-table = tablem.with(
  render: (columns: auto, ..args) => {
    table(
      columns: columns,
      stroke: none,
      align: center + horizon,
      table.hline(y: 0),
      table.hline(y: 1, stroke: .5pt),
      ..args,
      table.hline(),
    )
  },
)
