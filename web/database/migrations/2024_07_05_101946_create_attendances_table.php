<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('attendances', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            // in
            $table->timestamp('time_in');
            $table->string('image_in');
            $table->integer('late_in')->nullable();
            $table->string('latitude_in');
            $table->string('longitude_in');
            // out
            $table->timestamp('time_out')->nullable();
            $table->string('image_out')->nullable();
            $table->integer('late_out')->nullable();
            $table->string('latitude_out')->nullable();
            $table->string('longitude_out')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendances');
    }
};
