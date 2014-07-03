# Example Hives

A collection of example configurations in various situations with eHive (https://github.com/Ensembl/ensembl-hive).

## The Flow Example

### The Goal

This pipeline aims to demonstrate hive's ability to dataflow input_ids based upon a successful run of a module. Hive will flow a job for each successful run on flow number 1. If no flow number is specified 1 is assumed. The pipeline has 4 analyses with the following flow

```
        1           1
Start =====> Flow =====> End
                    |
                    ===> Alternative
                    2
```

The only module to define a call to `dataflow_output_id(input_id, branch)` is `Flow::Flow`. That specifically flows `{flow => 1}` to branch number 2. However because of the way eHive operates this means the job flows 2 jobs; one to Alternative (branch 2) and one to End (branch 1) as defined in our config file.

### How To Run

You will need

- eHive version 2.0 or greater
- [DBD::sqlite](https://metacpan.org/pod/DBD::SQLite)
- Export eHive onto your PERL5LIB
- Export eHive's scripts onto your PATH

```bash
# Setup the pipeline into SQLite3
cd example-hives
PERL5LIB=$PWD/lib:$PERL5LIB init_pipeline.pl lib/Config/Flow_conf.pm
export EHIVE_URL=sqlite:///${USER}_flow

beekeeper.pl -url $EHIVE_URL -sync
# Wait for the sync to finish

beekeeper.pl -url $EHIVE_URL -loop
# Wait for the loop
```

### Example Output

```bash
sqlite3 "${USER}_flow" select logic_name, input_id from analysis_base join job using (analysis_id)
```

You will see 4 rows in the job table with the expected `input_ids`. The flow of `Start -> Flow -> End` has retained our original input id. The alternative branch now has the new input_id.

```
Start|{"start" => 1}
Flow|{"start" => 1}
Alternative|{"flow" => 1}
End|{"start" => 1}
```