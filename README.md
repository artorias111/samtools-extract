# Samtools Extract Workflow

This Nextflow workflow extracts genomic regions from a FASTA file using samtools based on coordinates provided in a TSV file.

## Input Files

1. **FASTA file**: A reference genome in FASTA format
2. **Coordinates TSV file**: A tab-separated file with three columns:
   - Column 1: Contig/sequence name
   - Column 2: Start position (1-based)
   - Column 3: End position (inclusive)

Example coordinates file (`example_coordinates.tsv`):
```
contig1	100	200
contig1	500	600
contig2	1000	1100
contig3	50	150
```

## Usage

```bash
nextflow run main.nf --fasta your_genome.fasta --labels your_coordinates.tsv
```

## Output

The workflow will:
1. Create an index for your FASTA file using `samtools faidx`
2. Parse the coordinates file
3. Extract each region using `samtools faidx`
4. Save extracted regions as individual FASTA files in the `results` directory

Each extracted region will be named: `{contig}.{start}.{stop}.fa`

## Requirements

- Nextflow
- Samtools
- A FASTA file (will be automatically indexed)
- A TSV file with coordinates

## Example

```bash
# Run with example files
nextflow run main.nf --fasta genome.fasta --labels example_coordinates.tsv
```

This will extract 4 regions and save them as:
- `contig1.100.200.fa`
- `contig1.500.600.fa`
- `contig2.1000.1100.fa`
- `contig3.50.150.fa` 