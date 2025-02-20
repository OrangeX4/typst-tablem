# Tablem

Write markdown-like tables easily.

## Example

Have a look at the source [here](./examples/example.typ).

![Example](./examples/example.png)


## Usage

You can simply copy the markdown table and paste it in `tablem` function.

```typ
#import "@preview/tablem:0.1.0": tablem, three-line-table

#tablem[
  | *Name* | *Location* | *Height* | *Score* |
  | ------ | ---------- | -------- | ------- |
  | John   | Second St. | 180 cm   |  5      |
  | Wally  | Third Av.  | 160 cm   |  10     |
]
```

And you can use custom render function.

```typ
#import "@preview/tablem:0.1.0": tablem, three-line-table

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
  }
)

#three-line-table[
  | *Name* | *Location* | *Height* | *Score* |
  | ------ | ---------- | -------- | ------- |
  | John   | Second St. | 180 cm   |  5      |
  | Wally  | Third Av.  | 160 cm   |  10     |
]
```

![Example](./examples/example.png)


## `tablem` function

```typ
#let tablem(
  render: table,
  ignore-second-row: true,
  use-table-header: true,
  ..args,
  body
) = { .. }
```

**Arguments:**

- `render`: [`(columns: int, ..args) => { .. }`] &mdash; Custom render function, default to be `table`, receiving a integer-type columns, which is the count of first row. `..args` is the combination of `args` of `tablem` function and children genenerated from `body`.
- `ignore-second-row`: [`boolean`] &mdash; Whether to ignore the second row (something like `|---|`). Default to be `true`.
- `use-table-header`: [`boolean`] &mdash; Whether to use `table.header` wrapper for the first row. Default to be `true`.
- `args`: [`any`] &mdash; Some arguments you want to pass to `render` function.
- `body`: [`content`] &mdash; The markdown-like table. There should be no extra line breaks in it.


## Limitations

Cell merging has not yet been implemented.


## License

This project is licensed under the MIT License.
