<div>
    <div class="nxl-content">
        <!-- [ Main Content ] start -->
        <div class="main-content">
            <div class="row">
                <!-- [Hadir] start -->
                <div class="col-xxl-4">
                    <div class="card stretch stretch-full">
                        <div class="card-header">
                            <h5 class="card-title">Karyawan yang sudah pulang hari ini - {{
                                $this->presentUsers->count() }}/{{
                                $this->presentUsers->count() + $this->absentUsers->count() }}</h5>
                            <div class="card-header-action">
                                <div class="dropdown">
                                    <div data-bs-toggle="tooltip" title="Refresh">
                                        <a wire:click="$refresh" href="javascript:void(0);"
                                            class="avatar-text avatar-xs bg-warning"> </a>
                                    </div>
                                </div>
                                <div class="dropdown">
                                    <div data-bs-toggle="tooltip" title="Maximize/Minimize">
                                        <a href="javascript:void(0);" class="avatar-text avatar-xs bg-success"
                                            data-bs-toggle="expand"> </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body custom-card-action p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr class="border-b">
                                            <th scope="row">Nama</th>
                                            @if (count($this->presentUsers) != 0)
                                            <th>Waktu</th>
                                            <th>Status</th>
                                            @endif
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach ($this->presentUsers as $user)
                                        <tr wire:key="{{ $user->id }}">
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar-image">
                                                        <img src="assets/images/avatar/1.png" alt=""
                                                            class="img-fluid" />
                                                    </div>
                                                    <a href="javascript:void(0);">
                                                        <span class="d-block">{{ $user->name }}</span>
                                                    </a>
                                                </div>
                                            </td>
                                            <td> {{ $user->attendancesOutToday[0]->created_at->format('H:i') }}</td>
                                            <td>
                                                @if ($user->attendancesOutToday[0]->status == 'ontime')
                                                <span class="badge bg-soft-success text-success">
                                                    Tepat Waktu
                                                </span>
                                                @elseif($user->attendancesOutToday[0]->status == 'late')
                                                <span class="badge bg-soft-warning text-danger">
                                                    Terlambat
                                                </span>
                                                @endif
                                            </td>
                                        </tr>
                                        @endforeach
                                        @if (count($this->presentUsers) == 0)
                                        <tr>
                                            <td>
                                                <div class="d-flex justify-content-center align-items-center gap-3">
                                                    <span class="d-block">Belum ada yang pulang</span>
                                                </div>
                                            </td>
                                        </tr>
                                        @endif
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- [Hadir] start -->

                {{--
                <!-- [Tidak Hadir] start -->
                <div class="col-xxl-3 col-md-6">
                    <div class="card stretch stretch-full">
                        <div class="card-header">
                            <h5 class="card-title">Belum pulang - {{ $this->absentUsers->count() }}/{{
                                $this->absentUsers->count() + $this->presentUsers->count() }}</h5>
                            <div class="card-header-action">
                                <div class="dropdown">
                                    <div data-bs-toggle="tooltip" title="Refresh">
                                        <a wire:click="$refresh" href="javascript:void(0);"
                                            class="avatar-text avatar-xs bg-warning"> </a>
                                    </div>
                                </div>
                                <div class="dropdown">
                                    <div data-bs-toggle="tooltip" title="Maximize/Minimize">
                                        <a href="javascript:void(0);" class="avatar-text avatar-xs bg-success"
                                            data-bs-toggle="expand"> </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body custom-card-action p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr class="border-b">
                                            <th scope="row">Nama</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach ($this->absentUsers as $user)
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar-image">
                                                        <img src="assets/images/avatar/1.png" alt=""
                                                            class="img-fluid" />
                                                    </div>
                                                    <a href="javascript:void(0);">
                                                        <span class="d-block">{{ $user->name }}</span>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                        @endforeach
                                        @if (count($this->absentUsers) == 0)
                                        <tr>
                                            <td>
                                                <div class="d-flex justify-content-center align-items-center gap-3">
                                                    <span class="d-block">Semuanya sudah pulang</span>
                                                </div>
                                            </td>
                                        </tr>
                                        @endif
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- [Tidak Hadir] start --> --}}
            </div>
        </div>
        <!-- [ Main Content ] end -->
    </div>
    <script src="{{url('assets/vendors/js/daterangepicker.min.js')}}"></script>
    <script src="{{url('assets/vendors/js/apexcharts.min.js')}}"></script>
    <script src="{{url('assets/vendors/js/circle-progress.min.js')}}"></script>
    <script src="{{url('assets/js/dashboard-init.min.js')}}"></script>
</div>

@push('scripts')
<script>
    document.addEventListener('contentChanged', function(e) {
        loadScripts().then(function() {
            window.livewire.emit('scriptsLoaded');
        });
    });

    function loadScripts() {
        return new Promise((resolve, reject) => {
            $.getScript("{{url('assets/vendors/js/daterangepicker.min.js')}}", function() {
                $.getScript("{{url('assets/vendors/js/apexcharts.min.js')}}", function() {
                    $.getScript("{{url('assets/vendors/js/circle-progress.min.js')}}", function() {
                        $.getScript("{{url('assets/js/dashboard-init.min.js')}}", function() {
                            resolve();
                        }).fail(reject);
                    }).fail(reject);
                }).fail(reject);
            }).fail(reject);
        });
    }

    loadScripts().then(function() {
        window.livewire.emit('scriptsLoaded');
    });
</script>
@endpush

@push('styles')
<link rel="stylesheet" type="text/css" href="{{url('assets/vendors/css/daterangepicker.min.css')}}" />
@endpush