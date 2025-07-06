# Samtools Extract Workflow

Extract genomic regions from a FASTA file using samtools based on coordinates provided in a TSV file.

## Input Files

1. **FASTA file**: A reference genome in FASTA format
2. **Coordinates TSV file**: A tab-separated file with three columns:
   - Column 1: Contig/sequence name
   - Column 2: Start position (optional)
   - Column 3: End position (optional)
  
If columns 2 and 3 are not provided, the entire contig is extracted, and saved as `contig.full.fa`. 
Also note that the start and stopped can be flipped (for example, `contig1   500   300` is valid), if the strand is flipped, for example. The parser automatically figures this out. 

Example coordinates file (`example_coordinates.tsv`):
```
contig1	100	200
contig1	500	600
contig3
contig2	1200	1100
contig3	50	150
```

## Usage

```bash
nextflow run artorias111/samtools-extract --fasta your_genome.fasta --labels your_coordinates.tsv
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

## Example for local 

```bash
# Run with example files
nextflow run main.nf --fasta genome.fasta --labels example_coordinates.tsv
```

This will extract 5 regions and save them as:
- `contig1.100.200.fa`
- `contig1.500.600.fa`
- `contig3.full.fa`
- `contig2.1000.1100.fa`
- `contig3.50.150.fa` 
