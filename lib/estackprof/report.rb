# frozen_string_literal: true

require 'stackprof'

module Estackprof
  class Report < StackProf::Report
    def print_text(limit:, pattern:, sort_by_total: false, out: $stdout)
      print_summary(out)
      print_header(out)

      list = frames(sort_by_total)
      if pattern
        list = list.filter do |_frame, info|
          %i[file name].any? { |s| info[s].match?(pattern) }
        end
      end
      list = list.first(limit) if limit
      print_body(list, out)
    end

    private

    def print_summary(out)
      out.puts '=================================='
      out.printf "  Mode: #{modeline}\n"
      print_summary_samples(out)
      print_summary_gc(out)
      out.puts '=================================='
    end

    def print_summary_samples(out)
      out.printf "  Samples: #{@data[:samples]} (%.2f%% miss rate)\n",
                 100.0 * @data[:missed_samples] / (@data[:missed_samples] + @data[:samples])
    end

    def print_summary_gc(out)
      out.printf "  GC: #{@data[:gc_samples]} (%.2f%%)\n", 100.0 * @data[:gc_samples] / @data[:samples]
    end

    def print_header(out)
      out.printf format("%<total>10s    (pct)  %<samples>10s    (pct)     FRAME\n", total: 'TOTAL', samples: 'SAMPLES')
    end

    def print_body(list, out)
      list.each do |_frame, info|
        call, total = info.values_at(:samples, :total_samples)
        out.printf(
          "%<total>10d %<total_pct>8s  %<samples>10d %<samples_pct>8s     %<frame>s\n",
          total: total, total_pct: format('(%2.1f%%)', (total * 100.0 / overall_samples)),
          samples: call, samples_pct: format('(%2.1f%%)', (call * 100.0 / overall_samples)),
          frame: frame(info[:name], info[:file], info[:line])
        )
      end
    end

    def frame(name, file, line)
      file_path = name
      begin
        file_path += "(#{Pathname(file).relative_path_from(Dir.pwd)}:#{line})"
      rescue StandardError
        # NOP
      end
      file_path
    end
  end
end
